//
//  ViewController.m
//  BonjourClient
//
//  Created by Lin Chih-An on 2016/3/22.
//  Copyright © 2016年 Lin Chih-An. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.browser = [[NSNetServiceBrowser alloc] init];
    [self.browser setDelegate:self];
    [self.browser searchForServicesOfType:@"_ipp._tcp." inDomain:@""];
    self.count = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNetServiceBrowserDelegate

-(void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser
{
    NSLog(@"%s", __func__);
}

-(void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser
{
    NSLog(@"%s", __func__);
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *,NSNumber *> *)errorDict
{
    NSLog(@"%s", __func__);
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
    NSLog(@"%s", __func__);
    self.netService = service;
    [self.netService setDelegate:self];
    [self.netService resolveWithTimeout:5];
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing
{
    NSLog(@"%s", __func__);
}

#pragma mark - NSNetServiceDelegate

-(void)netService:(NSNetService *)sender didNotResolve:(NSDictionary<NSString *,NSNumber *> *)errorDict
{
    NSLog(@"%s", __func__);
}

-(void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSLog(@"%s", __func__);
    [self.netService getInputStream:&inputStream outputStream:&outputStream];
    
    [outputStream setDelegate:self];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [outputStream open];
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    NSLog(@"%s", __func__);
    switch(streamEvent)
    {
        case NSStreamEventHasBytesAvailable:
        {
            NSLog(@"available");
            break;
        }
        case NSStreamEventOpenCompleted:
            NSLog(@"open complete");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"end encounterd");
            break;
        case NSStreamEventErrorOccurred:
        {
            NSError *theError = [theStream streamError];
            NSLog(@"Error %li: %@", (long)[theError code], [theError localizedDescription]);
            [theStream close];
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            NSLog(@"space available");
            if(!self.count)
            {
                self.count++;
                const char *buff = "Hello World!";
                NSUInteger buffLen = strlen(buff);
                NSInteger writtenLength = [outputStream write:(const uint8_t *)buff maxLength:strlen(buff)];
//                NSLog(@"%ld", (long)writtenLength);
                if (writtenLength != buffLen)
                    [NSException raise:@"WriteFailure" format:@""];
            }
            break;
        }
        case NSStreamEventNone:
            NSLog(@"event none");
            break;
    }
}

@end
