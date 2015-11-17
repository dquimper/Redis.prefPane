//
//  Redis.m
//  Redis
//
//  Created by Daniel Quimper on 12-06-27.
//  Copyright (c) 2012 Daniel Quimper. All rights reserved.
//

#import "Redis.h"

#define LAUNCHCTL @"/bin/launchctl"
#define WHICH @"/usr/bin/which"
#define ECHO @"/bin/echo"
#define FIND @"/usr/bin/find"
#define REDIS_CLI @"redis-cli"
#define REDIS_SERVER @"redis-server"

@implementation Redis

@synthesize path = _path;
@synthesize startButton = _startButton;
@synthesize statusLabel = _statusLabel;
@synthesize autoStartCheckBox = _autoStartCheckBox;
@synthesize detailInformationText = _detailInformationText;
@synthesize progressIndicator = _progressIndicator;
@synthesize redis_cli = _redis_cli;
@synthesize redis_server = _redis_server;
@synthesize redis_conf = _redis_conf;
@synthesize launchctl = _launchctl;
@synthesize startedSubtext = _startedSubtext;
@synthesize statusImage = _statusImage;

- (void)updateChrome {
    NSString *startedPath = [self.bundle pathForResource:@"started" ofType:@"png"];
    NSImage *started = [[NSImage alloc] initWithContentsOfFile:startedPath];
    
    NSString *stoppedPath = [self.bundle pathForResource:@"stopped" ofType:@"png"];
    NSImage *stopped = [[NSImage alloc] initWithContentsOfFile:stoppedPath];
    
    if (_isRunning) {
        (self.startButton).title = @"Stop Redis Server";
        [self.detailInformationText setStringValue:@"The Redis Database Server is started and ready for client connections. To shut the Server down, use the \"Stop Redis Server\" button."];
        (self.statusLabel).textColor = [NSColor greenColor];
        [self.statusLabel setStringValue:@"Running"];
        [self.startedSubtext setHidden:NO];
        (self.statusImage).image = started; 
        
    }
    else {
        (self.startButton).title = @"Start Redis Server";
        [self.detailInformationText setStringValue:@"The Redis Database Server is currently stopped. To start it, use the \"Start Redis Server\" button."];
        [self.statusLabel setStringValue:@"Stopped"];
        (self.statusLabel).textColor = [NSColor redColor];
        [self.startedSubtext setHidden:YES];
        (self.statusImage).image = stopped;
    }
    [self.progressIndicator stopAnimation:self];
}

- (NSString *)runCLICommand:(NSString *)command arguments:(NSArray *)args waitUntilExit:(BOOL)wait {
    
    NSTask *task;
    task = [[NSTask alloc] init];
    task.launchPath = command;
    task.arguments = args;
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    task.standardOutput = pipe;
    //The magic line that keeps your log where it belongs
    task.standardInput = [NSPipe pipe];
    
    NSFileHandle *file;
    file = pipe.fileHandleForReading;
    
    [task launch];
    
    if (wait) {
        [task waitUntilExit];
    }
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data
                                   encoding: NSUTF8StringEncoding];
    return string;    
}

- (NSString *)runCLICommand:(NSString *)command arguments:(NSArray *)args {
    return [self runCLICommand:command arguments:args waitUntilExit:NO];
}

////////////////////////////////////////////////////////////////////////////
// redis-cli ping
// launchctl list homebrew.mxcl.redis
////////////////////////////////////////////////////////////////////////////
- (void)checkServerStatus {
    // Find out if Redis server is running
    NSArray *args = @[@"PING"];
    NSString *result = [self runCLICommand:self.redis_cli arguments:args];
    if ([result rangeOfString:@"PONG"].location != NSNotFound) {
        _isRunning = YES;        
    }
    else {
        _isRunning = NO;
    }
    
    // Set the running/stopped label and set the button text to correct
    // Check if Auto-start is enabled and set checkbox accordingly
    args = @[@"list",@"homebrew.mxcl.redis"];
    NSString *autoS = [self runCLICommand:LAUNCHCTL arguments:args waitUntilExit:NO];
    
    if (autoS.length == 0 || [autoS isEqualToString:@"launchctl list returned unknown response"]) {
        (self.autoStartCheckBox).state = 0;
    }
    else {
        (self.autoStartCheckBox).state = 1;
    }
    
    [self performSelectorOnMainThread:@selector(updateChrome) withObject:nil waitUntilDone:NO];
    
}

- (void)startup {
    NSArray *args = nil;
    
    args = [NSArray arrayWithObjects: LAUNCHCTL, nil];
    self.launchctl = [self runCLICommand:WHICH arguments:args];
    self.launchctl = [self.launchctl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
    args = [NSArray arrayWithObjects:@"/usr/local/Cellar",@"-type", @"f", @"-name", REDIS_CLI, nil];
    self.redis_cli = [self runCLICommand:FIND arguments:args];
    self.redis_cli = [self.redis_cli stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  
    args = [NSArray arrayWithObjects:@"/usr/local/Cellar",@"-type", @"f", @"-name", REDIS_SERVER, nil];
    self.redis_server = [self runCLICommand:FIND arguments:args];
    self.redis_server = [self.redis_server stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
    args = [NSArray arrayWithObjects:@"/usr/local/etc",@"-type", @"f", @"-name", @"redis.conf", nil];
    self.redis_conf = [self runCLICommand:FIND arguments:args];
    self.redis_conf = [self.redis_conf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
//    [self.startButton setTitle:self.redis_cli];
//    [self.detailInformationText setTitleWithMnemonic:self.redis_server];

    // Don't proceed. Disable everything.
    if ((self.redis_cli).length == 0) {
        [self.startButton setEnabled:NO];
        [self.autoStartCheckBox setEnabled:NO];
    }
    else {
        [self checkServerStatus];
    }
}

// For checking after user closes or choses Show All option.
- (void)didSelect {
    [self startup];
}

- (void)mainViewDidLoad
{
    _isRunning = NO;
    [self startup];
    
}

////////////////////////////////////////////////////////////////////////////
// redis-server /usr/local/etc/redis.conf
// redis-cli shutdown
////////////////////////////////////////////////////////////////////////////
- (IBAction)startStopServer:(id)sender {
    
    [self.progressIndicator startAnimation:self];
    
    NSArray *args = nil;
    if(_isRunning) {
        (self.startButton).title = @"Stop Redis Server";
        args = @[@"shutdown"];
        [self runCLICommand:self.redis_cli arguments:args waitUntilExit:YES];
    }
    else {
        (self.startButton).title = @"Start Redis Server";
        args = @[self.redis_conf];        
        [self runCLICommand:self.redis_server arguments:args waitUntilExit:YES];
    }
    
    // update the chrome after done
    [self performSelector:@selector(checkServerStatus) withObject:nil afterDelay:3.0];
}


////////////////////////////////////////////////////////////////////////////
// launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
// launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
////////////////////////////////////////////////////////////////////////////
- (IBAction)autoStartChanged:(id)sender {
    NSArray *args = nil;
    
    [self.progressIndicator startAnimation:self];
    
    NSString *plist = (@"~/Library/LaunchAgents/homebrew.mxcl.redis.plist").stringByExpandingTildeInPath;
    
    if ((self.autoStartCheckBox).state == 0) {        
        // launchctl unload -w ~/Library/LaunchAgents/org.postgresql.postgres.plist
        args = @[@"unload", @"-w", plist];
        [self runCLICommand:self.launchctl arguments:args];
        
    } else {
        // launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist
        args = @[@"load", @"-w", plist];
        [self runCLICommand:self.launchctl arguments:args];
    }
    // update the chrome after done
    [self performSelector:@selector(checkServerStatus) withObject:nil afterDelay:3.0];
}


@end
