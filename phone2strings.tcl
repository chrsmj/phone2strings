#!/usr/bin/tclsh

# phone2strings.tcl
# Converts telephone number into vanity letter strings.
# Copyright 2019 chris at penguin pbx dot com
# License GPLv3

# potentially dirty user data passed in via command line
set unsafe_phone [string trim [lindex $argv 0]]

# dictionary of numbers-to-letters as seen on phone key pad
set d_keypad [dict create 0 {0} 1 {1} 2 {A B C} 3 {D E F} 4 {G H I} 5 {J K L} 6 {M N O} 7 {P Q R S} 8 {T U V} 9 {W X Y Z}]

# where to store the results for display
set l_outstrings [list]

if { [string length $unsafe_phone] == 0 } {
    puts "Usage: tclsh phone2strings.tcl 7203242729"
    puts "(where 7203242729 is the number you want to map out)"
    puts "PROTIP: pipe '|' the output to 'less'"
    exit
}

if { [string length $unsafe_phone] >= 15 } {
    puts "I'm sorry Dave, but I can't let you do that!"
    puts "Please try a shorter phone number less than 15 digits long."
    exit
}

foreach s_maybedigit [split $unsafe_phone {}] {
    if { ! [string is integer $s_maybedigit] } {
        puts "I'm sorry Dave, but I can't let you do that!"
        puts "Please try digits 0-9 only."
        exit
    }
}

# now a safe clean phone number
set s_phone $unsafe_phone

# BEGIN FUN ALGORITHM
foreach s_digit [split $s_phone {}] {
    set l_chars [dict get $d_keypad $s_digit]
    if { [llength $l_outstrings] == 0 } {
        # on the first number, not much to do...
        set l_outstrings $l_chars
    } else {
        set l_tmpstrings [list]
        foreach s $l_outstrings {
            foreach c $l_chars {
                lappend l_tmpstrings $s$c
            } 
        }
        set l_outstrings $l_tmpstrings
    }
}
# END FUN ALGORITHM

# If this were a web page, then continuous output would be better;
# but it is designed to run on the command line, so buy some RAM.
foreach s $l_outstrings {
    puts $s
}

