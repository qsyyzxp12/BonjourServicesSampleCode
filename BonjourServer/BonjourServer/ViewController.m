//
//  ViewController.m
//  BonjourServer
//
//  Created by Lin Chih-An on 2016/3/22.
//  Copyright © 2016年 Lin Chih-An. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service =  [[NSNetService alloc] initWithDomain:@"" type:@"_ipp._tcp" name:@"Canon MP780" port:4721];
    if(self.service)
    {
        self.service.delegate = self;
        [self.service publishWithOptions:NSNetServiceListenForConnections];
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - NSNetServiceDelegate

-(void)netServiceWillPublish:(NSNetService *)sender
{
    NSLog(@"%s", __func__);
}

-(void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"%s", __func__);
}

-(void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *,NSNumber *> *)errorDict
{
    NSLog(@"%s", __func__);
}

-(void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)InputStream outputStream:(NSOutputStream *)OutputStream
{
    NSLog(@"%s", __func__);
    inputStream = InputStream;
    outputStream = OutputStream;
//    [self.service getInputStream:&inputStream outputStream:&outputStream];
    
    [InputStream setDelegate:self];
    [InputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [InputStream open];
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
            if(!self.count)
            {
                self.count++;
                uint8_t buff[1024];
                bzero(buff, sizeof(buff));
                NSInteger readLength = [inputStream read:buff maxLength:sizeof(buff) - 1];
                buff[readLength] = '\0';
                NSLog(@"Read: %s", (char *)buff);
            }
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
            NSLog(@"space available");
            break;
        case NSStreamEventNone:
            NSLog(@"event none");
            break;
    }
}

@end
