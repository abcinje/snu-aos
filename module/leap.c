#include <linux/mm.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/sched/signal.h>

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Kernel module to enable/disable Leap components");

char *cmd;
MODULE_PARM_DESC(cmd, "A string, for prefetch load/unload command");
module_param(cmd, charp, 0000);

static void usage(void)
{
        printk(KERN_INFO "To enable prefetching: insmod leap_functionality.ko cmd=\"prefetch\"\n");
        printk(KERN_INFO "To disable prefetching: insmod leap_functionality.ko cmd=\"readahead\"\n");
        printk(KERN_INFO "To have swap info log: insmod leap_functionality.ko cmd=\"log\"\n");
}

static int __init leap_init(void)
{
	if (strcmp(cmd, "prefetch") == 0) {
		init_swap_trend(32);
		set_custom_prefetch(1);
	} else if (strcmp(cmd, "readahead") == 0) {
		set_custom_prefetch(0);
	} else if (strcmp(cmd, "log") == 0) {
		swap_info_log();
	} else {
		usage();
	}

	return 0;
}

static void __exit leap_exit(void)
{
	printk(KERN_INFO "Cleaning up leap module.\n");
}

module_init(leap_init);
module_exit(leap_exit);
