import * as path from "jsr:@std/path";

async function getAllFilesInDir(path: string) {
  const files = [];
  try {
    await Deno.lstat(path);
  } catch (error) {
    if (error && error instanceof Deno.errors.NotFound) {
      await Deno.mkdir(path);
    }
  }
  const walker = Deno.readDir(path);
  for await (const f of walker) {
    files.push(f);
  }

  return files;
}

async function makeNewADR(
  adrdir: string,
  n: number,
  name: string,
): Promise<Deno.DirEntry> {
  const paddedNum = n.toString().padStart(5, "0");
  const fileName = `${paddedNum}-${name}.md`;
  const file = await Deno.create(path.join(adrdir, fileName));
  const encoder = new TextEncoder();
  const contents = encoder.encode(`# ${paddedNum} - ${name}
## Abstract

## Context and Problem Statement

## Considered Options

## Decision Outcome

<!-- Add additional information here, comparsion of options, research, etc -->
  `);
  await file.write(contents);
  return {
    name: fileName,
    isFile: true,
    isDirectory: false,
    isSymlink: false,
  };
}

async function rebuildReadme(adrDirPath: string, files: Array<Deno.DirEntry>) {
  files.sort((a, b) => {
    if (a.name.startsWith("README")) {
      return -9999999;
    }
    return parseInt(a.name.substring(0, 6)) - parseInt(b.name.substring(0, 6));
  });
  await Deno.writeTextFile(
    path.join(adrDirPath, "README.md"),
    `# Architecture Decision Records
    
This directory captures architecture decision records for this project.
An architecture decision record is a justified software design choice 
that addresses a functional or non-functional requirement of architectural significance.

This directory and README is managed by adl. Please use \`adl create\` to create a new ADR.
If you need to regenerate this readme without creating a new ADR, please use \`adl regen\`.

## Contents 

${
      files.filter((f) => f.isFile).map((f) => {
        return `- [${f.name}](./${f.name})`;
      }).join("\n")
    }

Last generated ${new Date().toISOString()}
`,
  );
}

// Learn more at https://docs.deno.com/runtime/manual/examples/module_metadata#concepts
if (import.meta.main) {
  let adrdir = Deno.cwd();
  if (!adrdir.endsWith("adr")) {
    // we need to add the adr folder
    adrdir = path.join(adrdir, "adr");
  }

  const files = await getAllFilesInDir(adrdir);
  const adrsOnly = files.filter((f) => /^\d{5}-.*$/.test(f.name));
  const action = Deno.args[0];

  if (action == "create") {
    const name = Deno.args.slice(1).join(" ");
    const newFile = await makeNewADR(adrdir, adrsOnly.length, name);
    files.push(newFile);
  }

  await rebuildReadme(adrdir, files);
}
