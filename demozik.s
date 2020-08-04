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

music_thread_entry:
	.rept	1000
	move.w	#$770,$ffff8240.w
	clr.w	$ffff8240.w
	.endr
	move.w	#$2700,sr
	clr.b	music_thread_ready
	jsr	switch_threads
	bra	music_thread_entry
