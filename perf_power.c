#ifndef PERF_TYPE_POWER
#define PERF_TYPE_POWER           6
#endif
#ifndef PERF_COUNT_HW_ENERGY_PKG
#define PERF_COUNT_HW_ENERGY_PKG  0
#endif

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <sys/ioctl.h>
#include <errno.h>

static int perf_fd = -1;
static double total_energy = 0.0;
static uint64_t prev_count = 0;

// Wrapper for perf_event_open syscall
static long perf_event_open(struct perf_event_attr *hw_event, pid_t pid,
                            int cpu, int group_fd, unsigned long flags) {
    return syscall(__NR_perf_event_open, hw_event, pid, cpu, group_fd, flags);
}

void cleanup_and_exit(int sig) {
    // Print total energy in joules with higher precision
    printf("\nTotal energy used: %.6f J\n", total_energy);
    if (perf_fd >= 0)
        close(perf_fd);
    exit(0);
}

int main(int argc, char **argv) {
    struct perf_event_attr pe;
    memset(&pe, 0, sizeof(struct perf_event_attr));
    pe.type = PERF_TYPE_POWER;
    pe.size = sizeof(struct perf_event_attr);
    pe.config = PERF_COUNT_HW_ENERGY_PKG;
    pe.disabled = 0;
    pe.exclude_kernel = 0;
    pe.exclude_hv = 1;

    // Open for measuring on all CPUs
    perf_fd = perf_event_open(&pe, 0, -1, -1, 0);
    if (perf_fd == -1) {
        perror("perf_event_open");
        return 1;
    }

    // Set up signal handler for CTRL+C
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = &cleanup_and_exit;
    sigaction(SIGINT, &sa, NULL);

    // Initial read
    if (read(perf_fd, &prev_count, sizeof(uint64_t)) != sizeof(uint64_t)) {
        perror("read");
        close(perf_fd);
        return 1;
    }

    printf("Measuring CPU package power... (Press Ctrl+C to stop)\n");

    while (1) {
        sleep(1);
        uint64_t count;
        if (read(perf_fd, &count, sizeof(uint64_t)) != sizeof(uint64_t)) {
            perror("read");
            break;
        }
        // energy in joules
        double joules = (double)(count - prev_count) / 1e9; // counter in nanojoules
        double watts = joules; // since time interval is 1s
        total_energy += joules;
        prev_count = count;

        // Print power with more decimal places
        printf("Power: %.6f W\n", watts);
    }

    cleanup_and_exit(0);
    return 0;
}

