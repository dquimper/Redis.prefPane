//
//  Redis.h
//  Redis
//
//  Created by Daniel Quimper on 12-06-27.
//  Copyright (c) 2012 Daniel Quimper. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import <AppKit/AppKit.h>

@interface Redis : NSPreferencePane {
@private
    NSString *_path;
    NSButton *__strong _startButton;
    NSTextField *__strong _statusLabel;
    NSButton *__strong _autoStartCheckBox;
    NSTextField *__strong _detailInformationText;
    NSProgressIndicator *__strong _progressIndicator;
    
    NSString *_redis_cli;
    NSString *_redis_server;
    NSString *_redis_conf;
    NSString *_launchctl;
    NSString *_brew_prefix;
    NSTextField *__strong _startedSubtext;
    NSImageView *__strong _statusImage;
    
    BOOL _isRunning;
    
}

@property(nonatomic, strong) NSString *path;
@property (strong) IBOutlet NSButton *startButton;
@property (strong) IBOutlet NSTextField *statusLabel;
@property (strong) IBOutlet NSButton *autoStartCheckBox;
@property (strong) IBOutlet NSTextField *detailInformationText;
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;
@property (nonatomic, strong) NSString *redis_cli;
@property (nonatomic, strong) NSString *redis_server;
@property (nonatomic, strong) NSString *redis_conf;
@property (nonatomic, strong) NSString *brew_prefix;
@property (nonatomic, strong) NSString *launchctl;
@property (strong) IBOutlet NSTextField *startedSubtext;
@property (strong) IBOutlet NSImageView *statusImage;

- (void)mainViewDidLoad;
- (IBAction)startStopServer:(id)sender;
- (IBAction)autoStartChanged:(id)sender;

@end
