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
	

	raw_file, ok := os.read_entire_file("data/day1.txt")

	string_file : string = string(raw_file)


	t_start := time.now()

	
	part_2(&string_file)

	t_dur := time.diff(t_start, time.now())

	fmt.printf("--------------------------------\n")
	fmt.printf("  Time: %v\n", t_dur)
	fmt.printf("--------------------------------\n")
	
}

part_1 :: proc(string_file : ^string) {

	left  : [dynamic]int
	right : [dynamic]int

	even : bool
	for tok in strings.fields_iterator(string_file) {

		num, ok := strconv.parse_int(tok)
		if even {
			
			append(&right, num)
		}
		else {
			append(&left, num)
		}
		
		even = !even
	}

	slice.sort(left[:])
	slice.sort(right[:])

	total : int = 0
	for i in 0..<len(left) {

		dist := math.abs(right[i] - left[i])
		total += dist
	}

	fmt.printfln("Total Distance : %v", total)
}


part_2 :: proc(string_file : ^string) {
	left  : [dynamic]int
	right : [dynamic]int

	appearance_in_second : map[int]int

	even : bool
	for tok in strings.fields_iterator(string_file) {

		num, ok := strconv.parse_int(tok)
		if even {
			append(&right, num)
			appearance_in_second[num] += 1
		}
		else {
			append(&left, num)
		}
		
		even = !even
	}

	total_similarity_score := 0

	for num in left {
		if num in appearance_in_second {
			total_similarity_score += num * appearance_in_second[num]
		} 
	}

	fmt.printfln("Similiarity Score : %v", total_similarity_score)

}