package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:math"
import "core:slice"
import "core:time"

main :: proc() 
{
	fmt.printfln("Day 2 !")
	raw_file, ok := os.read_entire_file("data/day2.txt")

	string_file : string = string(raw_file)


	t_start := time.now()

	part_2(&string_file)

	t_dur := time.diff(t_start, time.now())

	fmt.printf("--------------------------------\n")
	fmt.printf("  Time: %v\n", t_dur)
	fmt.printf("--------------------------------\n")
}


part_1 :: proc(string_file : ^string) {

	safe_reports := 0

	for line in strings.split_lines_iterator(string_file)
	{
		line := line
		num  := -1
		sign := 0
		is_valid := true

		report_check: for tok in strings.fields_iterator(&line)
		{
			new_num := strconv.atoi(tok)

			if num != -1 {

				diff := num - new_num
				
				if math.abs(diff) > 3 {
					is_valid = false
					break report_check
				}

				if diff == 0 {
					is_valid = false
					break report_check
				}

				new_sign := diff < 0 ? -1 : 1

				if sign != 0 {
					if sign != new_sign {
						is_valid = false
						break report_check
					} 
				}

				sign = new_sign
			}

			num = new_num
		}

		if is_valid {
			safe_reports += 1
		}
	}

	fmt.printfln("Safe reports : %v", safe_reports)

}

part_2 :: proc(string_file : ^string) {

	safe_reports := 0

	for line in strings.split_lines_iterator(string_file)
	{
		line := line
		num  := -1
		sign := 0
		is_valid := true

		skip_count := 0

		nums_as_text, _ := strings.fields(line)

		nums : [dynamic]int

		for n in nums_as_text {
			append(&nums, strconv.atoi(n))
		}

		check_list :: proc(list : [dynamic]int, skip_num : int) -> bool {

			prev_num := list[0]
			start_iter := 1

			if skip_num == 0 {
				prev_num = list[1]
				start_iter = 2
			}
			

			sign := 0
			for i in start_iter..<len(list) {

				if i == skip_num { continue }

				curr_num := list[i]
				diff := prev_num - curr_num

				if diff == 0 {
					return false
				}

				if math.abs(diff) > 3 {
					return false
				}

				new_sign := diff < 0 ? -1 : 1
	
				if sign != 0 {
					if sign != new_sign {
						return false
					} 
				}

				prev_num = curr_num
				sign = new_sign
			}

			return true
		}

		if !check_list(nums, -1) {
			additionnal_check: for check in 0..<len(nums) {
				if check_list(nums, check) {
					safe_reports += 1
					break additionnal_check
				}
			}
		}
		else
		{
			safe_reports += 1
		}
	}

	fmt.printfln("Safe reports : %v", safe_reports)

}


