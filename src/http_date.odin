package main

import "core:fmt"
import "core:time"
import "core:time/datetime"

get_http_date :: proc(allocator := context.allocator) -> string {
	now := time.now()
	date, _ := time.time_to_datetime(now)
	@(static) weekdays := []string {
		"Sunday",
		"Monday",
		"Tuesday",
		"Wednesday",
		"Thursday",
		"Friday",
		"Saturday",
	}
	@(static) months := []string {
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December",
	}

	ordinal, _ := datetime.date_to_ordinal(date)
	day_of_week := datetime.day_of_week(ordinal)
	return fmt.aprintf(
		"%s, %02d %s %04d %02d:%02d:%02d UTC",
		weekdays[day_of_week][0:3],
		date.day,
		months[date.month - 1][0:3],
		date.year,
		date.hour,
		date.minute,
		date.second,
		allocator = allocator,
	)
}
