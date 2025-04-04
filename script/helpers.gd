extends Node

class_name Helper

func check_if_arrays_are_the_same(array1:Array, array2:Array):
	return array2.all(func(element): return array1.has(element))
