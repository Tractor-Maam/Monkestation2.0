/obj/structure/desk_bell/departmental
	name = "department bell"
	desc = "The cornerstone of any customer service job. Ringing it sends an announcement to the relevant radio channel."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "desk_bell"
	layer = OBJ_LAYER
	anchored = FALSE
	pass_flags = PASSTABLE // Able to place on tables

	ring_cooldown_length = 0.6 SECONDS // twice as slow
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF // Nothing stops the bell.
	var/announce_cooldown_length = 60 SECONDS // WHAT? I CANT HEAR YOU OVER THE RADIO BEING SPAMMED.
	/// The cooldown for announcing the bell
	COOLDOWN_DECLARE(announce_cooldown)
	///The machine's internal radio, used to broadcast alerts.
	var/obj/item/radio/radio
	var/radio_channel = FREQ_COMMON
	///Location of bell to be used in the announcement.
	var/bell_location = "Front Desk"

/obj/structure/desk_bell/departmental/Initialize(mapload)
	. = ..()
	set_anchored(TRUE)
	radio = new(src)
	radio.canhear_range = 0
	radio.set_listening(FALSE)
	radio.frequency = radio_channel
	radio.freerange = TRUE
	radio.freqlock = RADIO_FREQENCY_LOCKED
	/*radio.command = TRUE // you want the clown to steal them and spam them in their office, be my guest and uncomment this.
	radio.use_command = TRUE*/

/obj/structure/desk_bell/departmental/wrench_act_secondary(mob/living/user, obj/item/tool)
	balloon_alert(user, "indestructable!") //Nothing.
	return FALSE

/obj/structure/desk_bell/screwdriver_act(mob/living/user, obj/item/tool) //they cant break, so screwdriver anchors it
	balloon_alert(user, "[anchored ? "un" : ""]securing...")
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 10 SECONDS)) //twice as long as machine frames, those are REVERSE screws your average spaceman isnt prepared for that!.
		balloon_alert(user, "[anchored ? "un" : ""]secured")
		set_anchored(!anchored)
		tool.play_tool_sound(src)
		return TOOL_ACT_TOOLTYPE_SUCCESS
	return FALSE

/obj/structure/desk_bell/departmental/check_clapper(mob/living/user)
	return //NOTHING.

/obj/structure/desk_bell/MouseDrop(obj/over_object, src_location, over_location)
	if(istype(over_object, /obj/vehicle/ridden/wheelchair))
		usr.balloon_alert(usr, "cannot use a department bell!")
		return // makes absolutely certain this cant be used for a wheelchair bell
	return ..()

/obj/structure/desk_bell/departmental/ring_bell(mob/living/user)
	. = ..()
	if(COOLDOWN_FINISHED(src, announce_cooldown) && announce_cooldown_length)
		COOLDOWN_START(src, announce_cooldown, announce_cooldown_length)
		balloon_alert(user, "department notified")
		var/message = "Assistance requested at [bell_location]."
		radio.talk_into(src, message, radio_channel)

/obj/structure/desk_bell/departmental/security
	radio_channel = FREQ_SECURITY

/obj/structure/desk_bell/departmental/engineering
	radio_channel = FREQ_ENGINEERING

/obj/structure/desk_bell/departmental/command
	radio_channel = FREQ_COMMAND

/obj/structure/desk_bell/departmental/command/hop
	bell_location = "Head of Personnel's Office"

/obj/structure/desk_bell/departmental/science
	radio_channel = FREQ_SCIENCE

/obj/structure/desk_bell/departmental/medical
	radio_channel = FREQ_MEDICAL

/obj/structure/desk_bell/departmental/supply
	radio_channel = FREQ_SUPPLY

/obj/structure/desk_bell/departmental/service
	radio_channel = FREQ_SERVICE
