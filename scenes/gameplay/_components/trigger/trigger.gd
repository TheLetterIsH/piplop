class_name Trigger
extends Node

signal finished(tag: String)

# Dictionary to hold active triggers
var triggers: Dictionary = {}

# Unique ID counter
var uid_counter: int = 0


# Helper function to generate unique IDs
func generate_uid() -> String:
	uid_counter += 1
	return str(uid_counter)


# Function to add a trigger to the dictionary
func add_trigger(tag: String, trigger: Dictionary) -> void:
	triggers[tag] = trigger


# Function to remove a trigger by tag
func remove_trigger(tag: String) -> void:
	triggers.erase(tag)


# Executes only if the condition is met after the cooldown delay
func cooldown(delay: float, condition: Callable, action: Callable, times: int = 0, tag: String = "") -> String:
	tag = tag if tag != "" else generate_uid()
	
	var trigger = {
		"type": "cooldown",     # Executes based on a condition
		"timer": 0.0,           # Timer to track delay
		"delay": delay,         # Cooldown duration
		"condition": condition, # Condition function that must return true
		"action": action,       # Action to perform
		"times": times,         # Number of executions (0 for infinite)
		"tag": tag              # Identifier for trigger
	}
	
	add_trigger(tag, trigger)
	
	return tag


# Runs a callable action after a specified delay
func after(delay: float, action: Callable, tag: String = "") -> String:
	tag = tag if tag != "" else generate_uid()
	
	var trigger = {
		"type": "after",    # Executes once after delay
		"timer": 0.0,       # Timer to track elapsed time
		"delay": delay,     # Time before execution
		"action": action,   # Action to be performed
		"times": 1,         # Only executes once
		"repeat": false,    # Does not repeat
		"tag": tag          # Identifier for trigger
	}
	
	add_trigger(tag, trigger)
	
	return tag


# Runs a callable action at intervals a specified number of times
func every(delay: float, times: int, action: Callable, after: Callable = func(): pass, tag: String = "") -> String:
	tag = tag if tag != "" else generate_uid()
	
	var trigger = {
		"type": "every",    # Executes multiple times at intervals
		"timer": 0.0,       # Timer to track interval
		"delay": delay,     # Interval duration
		"action": action,   # Action to be performed
		"times": times,     # Number of executions
		"repeat": true,     # Repeats until times reaches 0
		"after": after,     # Callable that is performed after the last action
		"tag": tag          # Identifier for trigger
	}
	
	add_trigger(tag, trigger)
	
	return tag


# Runs a callable action immediately, then repeats at intervals
func every_immediate(delay: float, times: int, action: Callable, after: Callable = func(): pass, tag: String = "") -> String:
	tag = tag if tag != "" else generate_uid()
	
	var trigger = {
		"type": "every_immediate", # Executes immediately, then repeats
		"timer": 0.0,              # Timer to track interval
		"delay": delay,            # Interval duration
		"action": action,          # Action to be performed
		"times": times,            # Number of executions
		"repeat": true,            # Repeats until times reaches 0
		"after": after,            # Callable that is performed after the last action
		"tag": tag                 # Identifier for trigger
	}
	
	# Execute immediately
	action.call()
	
	# Add trigger to dictionary for future executions
	add_trigger(tag, trigger)
	
	return tag


func get_delay(tag: String) -> float:
	return triggers[tag]["delay"]


func get_duration(tag: String) -> float:
	return triggers[tag]["delay"] * triggers[tag]["times"]


func get_timer(tag: String) -> float:
	return triggers[tag]["timer"]


# Cancels a trigger by its tag
func cancel(tag: String) -> void:
	remove_trigger(tag)


# Resets a trigger's timer and execution count
func reset(tag: String) -> void:
	if triggers.has(tag):
		var trigger = triggers[tag]
		trigger["timer"] = 0.0
		trigger["times"] = trigger["times"] if trigger["repeat"] else 1


# Processes all triggers every frame
func _process(delta: float) -> void:
	var to_remove: Array = []  # Tracks triggers to remove
	
	for tag in triggers.keys():
		var trigger = triggers[tag]
		trigger["timer"] += delta
		
		# Handle each trigger type accordingly
		if trigger["type"] == "cooldown":
			if trigger["timer"] >= trigger["delay"] and trigger["condition"].call():
				trigger["action"].call()
				trigger["timer"] = 0.0
				if trigger["times"] > 0:
					trigger["times"] -= 1
					if trigger["times"] <= 0:
						finished.emit(tag)
						to_remove.append(tag)
		
		elif trigger["type"] == "after":
			if trigger["timer"] >= trigger["delay"]:
				trigger["action"].call()
				finished.emit(tag)
				to_remove.append(tag)
		
		elif trigger["type"] == "every":
			if trigger["timer"] >= trigger["delay"]:
				trigger["action"].call()
				trigger["timer"] -= trigger["delay"]
				if trigger["times"] > 0:
					trigger["times"] -= 1
					if trigger["times"] <= 0:
						trigger["after"].call()
						finished.emit(tag)
						to_remove.append(tag)
		
		elif trigger["type"] == "every_immediate":
			if trigger["timer"] >= trigger["delay"]:
				trigger["action"].call()
				trigger["timer"] -= trigger["delay"]
				if trigger["times"] > 0:
					trigger["times"] -= 1
					if trigger["times"] <= 0:
						trigger["after"].call()
						finished.emit(tag)
						to_remove.append(tag)
	
	# Remove completed triggers
	for tag in to_remove:
		remove_trigger(tag)
