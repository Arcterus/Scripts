#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, const char *argv[]) {
	int retval = 0;
	if(argc < 2) {
		fputs("Error: Need more commands\n", stderr);
		retval = 1;
	} else {
		setuid(0);
		int fd = open("/sys/class/leds/smc::kbd_backlight/brightness", O_RDWR);
		if(fd != -1) {
			if(!strcmp(argv[1], "write")) {
				if(argc < 3) {
					fputs("Error: Need a value to set the backlight to\n", stderr);
					retval = 1;
				} else {
					int count = 0;
					while(isdigit(argv[2][count])) count++;
					if(count) {
						write(fd, argv[2], strlen(argv[2]));
					} else {
						fprintf(stderr, "Error: Invalid input (%s)\n", argv[2]);
						retval = 3;
					}
				}
			} else if(!strcmp(argv[1], "read")) {
				char buffer[4];
				buffer[3] = 0;
				read(fd, buffer, sizeof(buffer) - 1);
				for(int i = 0; i < sizeof(buffer) - 1; i++) {
					if(!isdigit(buffer[i])) buffer[i] = 0;
				}
				puts(buffer);
			} else {
				fprintf(stderr, "Error: Invalid operation (%s)\n", argv[1]);
			}
			close(fd);
		} else {
			perror("Error");
			retval = 2;
		}
	}
	return retval;
}
