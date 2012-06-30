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
    NSButton *_startButton;
    NSTextField *_statusLabel;
    NSButton *_autoStartCheckBox;
    NSTextField *_detailInformationText;
    NSProgressIndicator *_progressIndicator;
    
    NSString *_redis_cli;
    NSString *_redis_server;
    NSString *_redis_conf;
    NSString *_launchctl;
    NSTextField *_startedSubtext;
    NSImageView *_statusImage;
    
    BOOL _isRunning;
    
}

@property(nonatomic, retain) NSString *path;
@property (assign) IBOutlet NSButton *startButton;
@property (assign) IBOutlet NSTextField *statusLabel;
@property (assign) IBOutlet NSButton *autoStartCheckBox;
@property (assign) IBOutlet NSTextField *detailInformationText;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
@property (nonatomic, retain) NSString *redis_cli;
@property (nonatomic, retain) NSString *redis_server;
@property (nonatomic, retain) NSString *redis_conf;
@property (nonatomic, retain) NSString *launchctl;
@property (assign) IBOutlet NSTextField *startedSubtext;
@property (assign) IBOutlet NSImageView *statusImage;

- (void)mainViewDidLoad;
- (IBAction)startStopServer:(id)sender;
- (IBAction)autoStartChanged:(id)sender;

@end
