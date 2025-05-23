# 00003 - Support Templates Folder

## Abstract

Being able to provide your own templates for the README and the ADRs
can be really useful. It allows you to customize this to your personal
or team needs while still sticking with the tool and processes for
maintaining proper ADRs.

## Context and Problem Statement

Currently, there is no way to deviate from the existing templates for
the README and the ADRs. If you want to customize these, you will lose all
changes upon regen of the README. Effectively, if you do not agree with
the templates that are shipped with ADL, the tool may not be useful to you.

## Considered Options

### Do Nothing
These templates are minimal and other additions can be captured elsewhere.

### Support user-driven templates
Create a templates directory and allow users to specify templates to be
used on behalf of the CLI when generated READMEs and ADRs. Specify the fields
via a templating language that the CLI can replace.

## Decision Outcome

We are going to support user-driven templates via a templates folder in the ADR directory. The templates folder should not be linked in the README contents.
The templates folder will also have it's own README with information on the
supported files that you can template, as well as the templating items that
can be replaced by the CLI such as timestamp or contents.

<!-- Add additional information here, comparison of options, research, etc -->
