;   Copyright 2020 Jean-Baptiste M. "JBQ" "Djaybee" Queru
;
;   Licensed under the Apache License, Version 2.0 (the "License");
;   you may not use this file except in compliance with the License.
;   You may obtain a copy of the License at
;
;       http://www.apache.org/licenses/LICENSE-2.0
;
;   Unless required by applicable law or agreed to in writing, software
;   distributed under the License is distributed on an "AS IS" BASIS,
;   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;   See the License for the specific language governing permissions and
;   limitations under the License.

	.text

update_thread_entry:
;;; Start customized code
	tst.l	front_drawn_data
	beq.s	.new_config

	move.l	most_recently_updated,a5
	move.l	next_to_update,a6
	move.w	(a5),d0
	addq.w	#1,d0
	cmp.w	#200,d0
	bne.s	.y_in_range
	moveq.l	#0,d0
.y_in_range:
	move.w	d0,(a6)

	bra.s	.config_done

.new_config:
	move.l	#y_draw1,front_drawn_data
	move.l	#y_draw2,front_to_draw_data
	move.l	#y_draw3,back_drawn_data
	move.l	#y_draw4,back_to_draw_data
	move.l	back_to_draw_data,most_recently_updated
	move.l	back_to_draw_data,next_to_update
.config_done:
;;; End customized code

	; Unblock draw thread, block this thread until it's ready again
	move.w	#$2700,sr
	move.l	next_to_update,most_recently_updated
	move.b	#1,draw_thread_ready
	clr.b	update_thread_ready
	jsr	switch_threads
; Check for a keypress
; NOTE: would be good to do that with an interrupt handler, but I'm lazy
	cmp.b	#$39,$fffffc02.w
	bne	update_thread_entry
	rts

draw_thread_entry:
;;; Start customized code
	move.l	back_buffer,a0
	move.l	back_drawn_data,a5
	move.l	back_to_draw_data,a6
	move.w	(a5),d0
	mulu.w	#160,d0
	clr.w	(a0,d0.w)
	move.w	(a6),d0
	mulu.w	#160,d0
	move.w	#$ffff,(a0,d0.w)
;;; End customized code

	; Block this thread until it's ready again
	move.w	#$2700,sr
	move.l	back_drawn_data,-(sp)
	move.l	back_to_draw_data,back_drawn_data
	move.l	(sp)+,back_to_draw_data
	move.l	back_to_draw_data,next_to_update
	clr.b	draw_thread_ready
	jsr	switch_threads
	bra.s	draw_thread_entry

main_thread_entry:
	move.w	#$707,$ffff8242.w
main_loop:
;;; Start customized code
	nop
;;; End customized code

	bra.s	main_loop

	.bss
	.even
y_draw1:
	ds.w	1
y_draw2:
	ds.w	1
y_draw3:
	ds.w	1
y_draw4:
	ds.w	1
