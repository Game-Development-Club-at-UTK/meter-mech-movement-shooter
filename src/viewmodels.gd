extends Node3D

#handles weapon switching and viewmodels
#with 4 arms, we can load in weapons on any of the 4 at any given time.
#each weapon node is positioned so that any duplicate added to the palm bone will be positioned correctly
#then we have references to the animation players themselves and the named markers

@onready var armAnimationPlayer1 = $hand2/arm/AnimationPlayer2
@onready var handAnimationPlayer1 = $hand2/arm/Skeleton3D/hand2/hand2/hand/AnimationPlayer2
@onready var handBoneAttachment1 = $hand2/arm/Skeleton3D/hand2

@onready var armAnimationPlayer2 = $hand3/arm/AnimationPlayer2
@onready var handAnimationPlayer2 = $hand3/arm/Skeleton3D/hand2/hand2/hand/AnimationPlayer2
@onready var handBoneAttachment2 = $hand3/arm/Skeleton3D/hand2

#@onready var armAnimationPlayer3 = $hand4/arm/AnimationPlayer2
#@onready var handAnimationPlayer3 = $hand4/arm/Skeleton3D/hand2/hand2/hand/AnimationPlayer2
#@onready var handBoneAttachment3 = $hand4/arm/Skeleton3D/hand2

#@onready var armAnimationPlayer4 = $hand5/arm/AnimationPlayer2
#@onready var handAnimationPlayer4 = $hand5/arm/Skeleton3D/hand2/hand2/hand/AnimationPlayer2
#@onready var handBoneAttachment4 = $hand5/arm/Skeleton3D/hand2

var currentArm #these just list current ones
var currentHand
var currentBoneAttachment
var currentWeaponAnimationPlayer

func _ready():
	
	_equip_weapon(0,2)
	_equip_weapon(1,4)
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_E:
			pass
		elif event.keycode == KEY_Q:
			pass
	
	
	
	if event is InputEventKey:
		if event.keycode == KEY_1:
			_play_weapon_animation(0,2,"tap")
			_play_weapon_animation(1,4,"tap")
		if event.keycode == KEY_2:
			_play_weapon_animation(0,2,"hold")
			_play_weapon_animation(1,4,"hold")
		if event.keycode == KEY_3:
			_play_weapon_animation(0,2,"release")
			_play_weapon_animation(1,4,"release")

#for playing weapon animations. 
#arm idx is 0-3, weaponIdx is 0-10, inputType is string "tap" "hold" "release"
#0 lasic2, 1 magenetohammer
func _play_weapon_animation(armIdx, weaponIdx, inputType):
	if armIdx == 0:
		currentArm = armAnimationPlayer1
		currentHand = handAnimationPlayer1
		currentBoneAttachment = handBoneAttachment1
		currentWeaponAnimationPlayer = currentBoneAttachment.get_child(-1).get_node("AnimationPlayer")
	elif armIdx == 1:
		currentArm = armAnimationPlayer2
		currentHand = handAnimationPlayer2
		currentBoneAttachment = handBoneAttachment2
		currentWeaponAnimationPlayer = currentBoneAttachment.get_child(-1).get_node("AnimationPlayer")
	
	if weaponIdx == 0: #lasik2
		if inputType == "tap":
			currentWeaponAnimationPlayer.play_section_with_markers("charge", "tap", "end")
			currentArm.play_section_with_markers("Action", "recoil1", "recoil2")
		if inputType == "hold":
			currentWeaponAnimationPlayer.play_section_with_markers("charge", "charge", "max")
		if inputType == "release":
			currentWeaponAnimationPlayer.play_section_with_markers("charge", "max", "tap")
			currentArm.play_section_with_markers("Action", "recoil2", "recoil3")
	elif weaponIdx == 1: #magnetohammer
		if inputType == "tap":
			currentArm.play_section_with_markers("Action", "hammerThrow", "end")
		if inputType == "hold":
			currentArm.play_section_with_markers("Action", "hammerStart", "hammerSwing")
		if inputType == "release":
			currentArm.play_section_with_markers("Action", "hammerSwing", "hammerThrow")
	elif weaponIdx == 2: #lasik5
		if inputType == "tap":
			currentWeaponAnimationPlayer.play_section_with_markers("action", "tap", "end")
			currentArm.play_section_with_markers("Action", "recoil1", "recoil2")
		if inputType == "hold":
			currentWeaponAnimationPlayer.play_section_with_markers("action", "start", "hold")
			currentArm.play_section_with_markers("Action", "inactive", "inactiveEnd")
		if inputType == "release":
			currentWeaponAnimationPlayer.play_section_with_markers("action", "hold", "end")
			currentArm.play_section_with_markers_backwards("Action", "inactive", "inactiveEnd")
	elif weaponIdx == 3: #capacitor1
		if inputType == "tap":
			currentArm.play_section_with_markers("Action", "recoil3", "throw")
	elif weaponIdx == 4: #lightningHand
		if inputType == "tap":
			#currentHand.play_section_with_markers_backwards("Action2", "flat3", "lightning")
			currentArm.play_section_with_markers("Action", "clap", "clapEnd")
		if inputType == "hold":
			currentHand.play_section_with_markers("Action2", "lightning", "lightningHold")
			#currentArm.play_section_with_markers("Action", "clap", "clapEnd")
		if inputType == "release":
			pass
			#currentHand.play_section_with_markers("Action2", "lightning", "lightningHold")
			#currentArm.play_section_with_markers("Action", "clap", "clapEnd")
	elif weaponIdx == 5: #drone
		if inputType == "tap":
			#currentHand.play_section_with_markers_backwards("Action2", "flat3", "lightning")
			currentArm.play_section_with_markers("Action", "throw", "shield")
	elif weaponIdx == 6: #oil drum
		if inputType == "tap":
			#currentHand.play_section_with_markers_backwards("Action2", "flat3", "lightning")
			currentArm.play_section_with_markers("Action", "throw", "shield")
	elif weaponIdx == 7: #tec9
		if inputType == "tap":
			#currentHand.play_section_with_markers_backwards("Action2", "flat3", "lightning")
			currentArm.play_section_with_markers("Action", "recoil1", "recoil2")


#arm idx is 0-3 again, weapon idx is 0-10
func _equip_weapon(armIdx, weaponIdx):
	if armIdx == 0:
		currentArm = armAnimationPlayer1
		currentHand = handAnimationPlayer1
		currentBoneAttachment = handBoneAttachment1
	elif armIdx == 1:
		currentArm = armAnimationPlayer2
		currentHand = handAnimationPlayer2
		currentBoneAttachment = handBoneAttachment2
	
	
	if weaponIdx == 0: #lasik2
		currentBoneAttachment.add_child($guns/lasik2.duplicate())
		currentHand.play_section_with_markers("Action2", "flat2", "grab2")
		currentArm.play_section_with_markers("Action", "in", "topOut")
	if weaponIdx == 1: #magnetohammer
		currentBoneAttachment.add_child($guns/magnetohammer.duplicate())
		currentHand.play_section_with_markers("Action2", "flat", "grab1")
		currentArm.play_section_with_markers("Action", "hammerStart", "hammerIdle")
	if weaponIdx == 2: #lasik5
		currentBoneAttachment.add_child($guns/lasik5.duplicate())
		currentHand.play_section_with_markers("Action2", "flat2", "grab2")
		currentArm.play_section_with_markers("Action", "in", "topOut")
	if weaponIdx == 3: #capacitor1
		currentBoneAttachment.add_child($guns/capacitor.duplicate())
		currentHand.play_section_with_markers("Action2", "flat2", "grab2")
		currentArm.play_section_with_markers("Action", "in", "topOut")
	if weaponIdx == 4: #lightning hand
		currentBoneAttachment.add_child($guns/capacitor2.duplicate())
		currentHand.play_section_with_markers("Action2", "flat3", "lightning")
		currentArm.play_section_with_markers("Action", "lightningStart", "clap")
	if weaponIdx == 5: #drone
		currentBoneAttachment.add_child($guns/drone.duplicate())
		currentHand.play_section_with_markers("Action2", "flat3", "lightning")
		currentArm.play_section_with_markers("Action", "throw", "shield")
	if weaponIdx == 6: #oilDrum
		currentBoneAttachment.add_child($guns/oildrum.duplicate())
		currentHand.play_section_with_markers("Action2", "flat3", "lightning")
		currentArm.play_section_with_markers("Action", "throw", "shield")
	if weaponIdx == 7: #tec9
		currentBoneAttachment.add_child($guns/tec9.duplicate())
		currentHand.play_section_with_markers("Action2", "flat", "grab1")
		currentArm.play_section_with_markers("Action", "in", "topOut")
	
	currentBoneAttachment.get_child(-1).visible = true
	currentBoneAttachment.get_child(-1).position = Vector3(0,0,0)
	currentBoneAttachment.get_child(-1).rotation = Vector3(0,0,0)
	
