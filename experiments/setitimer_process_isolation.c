#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/time.h>

/*
 * Launch multiple instances of this program on your machine with
 * different timeout values to convince yourself that itmer alarms
 * are specific to a particular process.
 */
 
int timeout;

void install_next_timer() {
  struct itimerval val;
  
  val.it_interval.tv_sec = 0;         /* ie. no repeat count */
  val.it_interval.tv_usec = 0; 
  val.it_value.tv_sec = timeout;      /* initialise counter */
  val.it_value.tv_usec = 0;
  
  setitimer(ITIMER_REAL, &val, 0);  
}


void custom_signal_handler()  
{
    time_t the_time;
  
    time(&the_time);
    fprintf(stdout, "alarm ticked at %d (epoch time)\n", the_time); 
    install_next_timer();
}


main(int argc, char *argv[])
{
    int i;
    struct itimerval val, curval;
    
    if (argc != 2 ) { 
        fprintf(stderr, "Usage: %s seconds\n", argv[0]);
        exit(1);
    }

    timeout = atoi(argv[1]);
    
    fprintf(stdout, "Setting alarm every %ds\n", timeout); 
    
    signal(SIGALRM, custom_signal_handler);

    install_next_timer();

    setitimer(ITIMER_REAL, &val, 0);
    for (;;) {
      sleep(1);
    }

}
