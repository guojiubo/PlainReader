//
//  CWActivityMonitor.m
//  PlainReader
//
//  Created by guojiubo on 10/22/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRActivityMonitor.h"
#include <mach/mach.h>
#include <malloc/malloc.h>

vm_size_t usedMemory(void);
vm_size_t freeMemory(void);

@interface PRActivityMonitor ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PRActivityMonitor

+ (instancetype)sharedMonitor
{
    static PRActivityMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[PRActivityMonitor alloc] init];
    });
    return monitor;
}

- (void)start
{
    if (self.timer) {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

- (void)stop
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)handleTimer:(NSTimer *)timer
{
    NSString *current = [NSString stringWithFormat:@"%.1fMB", (float)usedMemory()/1024.0/1024];
    NSString *left = [NSString stringWithFormat:@"%.1fMB", (float)freeMemory()/1024.0/1024];
    
    [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"%@/%@", current, left]];
}

vm_size_t usedMemory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

vm_size_t freeMemory(void) {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

@end
