//
//  SCNotificationCenter.m
//  SymSteam
//
//  Created by Alex Jackson on 26/07/2012.
//
//

#import "SCNotificationCenter.h"

@implementation SCNotificationCenter

#pragma mark - Singleton Stuff

- (id)init{
    self = [super init];
    if(self){
        Class notificationCenterClass = NSClassFromString(@"NSUserNotificationCenter");
            if(!notificationCenterClass)
                _systemNotificationCenterAvailable = NO;
            else
                _systemNotificationCenterAvailable = YES;
        if ([self getNotificationMethod] == SCNotificationCenterNotifyByAvailability)
            _useSystemNotificationCenter = _systemNotificationCenterAvailable;
        else if ([self getNotificationMethod] == SCNotificationCenterNotifyWithGrowl)
            _useSystemNotificationCenter = NO;
        else
            _useSystemNotificationCenter = YES;
    }
    return self;
}

+ (SCNotificationCenter *)sharedCenter {
    static dispatch_once_t pred;
    __strong static SCNotificationCenter *notificationCenter = nil;

    dispatch_once(&pred, ^{
        notificationCenter = [[self alloc] init];
    });

    return notificationCenter;
}

#pragma mark - Notification Method Preferences

- (BOOL)setNotificationMethodPreference:(SCNotificationMethod)preference {
    if (preference == SCNotificationCenterNotifyWithNotificationCenter && !self.systemNotificationCenterAvailable){
        NSLog(@"SCNotificatioNCenter: Attempted to enable NSUserNotificationCenter notifications but this system doesn't support them. Will continue to use Growl notifications.");
        return NO;
    }
    if (preference < SCNotificationCenterNotifyWithNotificationCenter || preference > SCNotificationCenterNotifyByAvailability) {
        NSLog(@"SCNotificationCenter: The provided notification method is invalid.");
        return NO;
    }

    else {
        [[NSUserDefaults standardUserDefaults] setValue:@(preference) forKey:@"SCNotificationMethod"];
        [self updateNotificationMethod];
        return YES;
    }
}

- (SCNotificationMethod)getNotificationMethod {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"SCNotificationMethod"];
}

#pragma mark - "Modern" Notification Display Methods

- (void)notifyWithDictionary:(NSDictionary *)dictionary{
    if(self.useSystemNotificationCenter)
        [self displayNotificationUsingNotificationCenterWithDetails:dictionary];
    else
        [self displayNotificationUsingGrowlWithDetails:dictionary];
}

+ (void)notifyWithDictionary:(NSDictionary *)dictionary{
    [[self sharedCenter] notifyWithDictionary:dictionary];
}

#pragma mark - Legacy Notification Methods

- (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
       notificationName:(NSString *)notifName
               iconData:(NSData *)iconData
               priority:(signed int)priority
               isSticky:(BOOL)isSticky
           clickContext:(id)clickContext{
    NSMutableDictionary *notificationDetails = [[NSMutableDictionary alloc] init];
    if(title)
        notificationDetails[SCNotificationCenterNotificationTitle] = title;
    if(description)
        notificationDetails[SCNotificationCenterNotificationDescription] = description;
    if(notifName)
        notificationDetails[SCNotificationCenterNotificationName] = notifName;
    if(iconData)
        notificationDetails[SCNotificationCenterNotificationIcon] = iconData;

    notificationDetails[SCNotificationCenterNotificationPriority] = @(priority);
    notificationDetails[SCNotificationCenterNotificationSticky] = @(isSticky);
    if(clickContext)
        notificationDetails[SCNotificationCenterNotificationClickContext] = clickContext;

    [self notifyWithDictionary:[notificationDetails copy]];

}

- (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
       notificationName:(NSString *)notifName
               iconData:(NSData *)iconData
               priority:(signed int)priority
               isSticky:(BOOL)isSticky
           clickContext:(id)clickContext
             identifier:(NSString *)indentifier{

    NSMutableDictionary *notificationDetails = [[NSMutableDictionary alloc] init];
    if(title)
        notificationDetails[SCNotificationCenterNotificationTitle] = title;
    if(description)
        notificationDetails[SCNotificationCenterNotificationDescription] = description;
    if(notifName)
        notificationDetails[SCNotificationCenterNotificationName] = notifName;
    if(iconData)
        notificationDetails[SCNotificationCenterNotificationIcon] = iconData;

    notificationDetails[SCNotificationCenterNotificationPriority] = @(priority);
    notificationDetails[SCNotificationCenterNotificationSticky] = @(isSticky);
    if(clickContext)
        notificationDetails[SCNotificationCenterNotificationClickContext] = clickContext;
    if(indentifier)
        notificationDetails[SCNotificationCenterNotificationIdentifier] = indentifier;

    [self notifyWithDictionary:[notificationDetails copy]];
}

+ (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
       notificationName:(NSString *)notifName
               iconData:(NSData *)iconData
               priority:(signed int)priority
               isSticky:(BOOL)isSticky
           clickContext:(id)clickContext{
    [[self sharedCenter] notifyWithTitle:title
                             description:description
                        notificationName:notifName
                                iconData:iconData
                                priority:priority
                                isSticky:isSticky
                            clickContext:clickContext];
}

+ (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
       notificationName:(NSString *)notifName
               iconData:(NSData *)iconData
               priority:(signed int)priority
               isSticky:(BOOL)isSticky
           clickContext:(id)clickContext
             identifier:(NSString *)indentifier{
    [[self sharedCenter] notifyWithTitle:title
                             description:description
                        notificationName:notifName
                                iconData:iconData
                                priority:priority
                                isSticky:isSticky
                            clickContext:clickContext
                              identifier: indentifier];
}

#pragma mark - Private Methods

- (void)displayNotificationUsingNotificationCenterWithDetails:(NSDictionary *)details{
    BOOL scheduledNotification = NO;

    NSUserNotification *notification = [[NSUserNotification alloc] init];
    if(details[SCNotificationCenterNotificationTitle])
        notification.title = details[SCNotificationCenterNotificationTitle];

    if(details[SCNotificationCenterNotificationDescription])
        notification.informativeText = details[SCNotificationCenterNotificationDescription];

    if(details[SCNotificationCenterNotificationSubtitle])
        notification.subtitle = details[SCNotificationCenterNotificationSubtitle];

    if(details[SCNotificationCenterNotificationSound])
        notification.soundName = details[SCNotificationCenterNotificationSound];

    if(details[SCNotificationCenterNotificationHasActionButton])
        notification.hasActionButton = [details[SCNotificationCenterNotificationHasActionButton] boolValue];

    if(details[SCNotificationCenterNotificationActionButtonTitle])
        notification.actionButtonTitle = details[SCNotificationCenterNotificationActionButtonTitle];

    if(details[SCNotificationCenterNotificationDeliveryDate]){
        notification.deliveryDate = details[SCNotificationCenterNotificationDeliveryDate];
        scheduledNotification = YES;
    }

    // Build the userInfo dictionary.
    NSMutableDictionary *userInfo;

    if(!details[SCNotificationCenterNotificationUserInfo]){
        userInfo = [[NSMutableDictionary alloc] init];
    }
    else{
        userInfo = [details[SCNotificationCenterNotificationUserInfo] mutableCopy];
    }

    if(details[SCNotificationCenterNotificationClickContext])
        userInfo[SCNotificationCenterNotificationClickContext] = details[SCNotificationCenterNotificationClickContext];

    if(details[SCNotificationCenterNotificationIdentifier])
        userInfo[SCNotificationCenterGrowlNotificationIdentifier] = details[SCNotificationCenterNotificationIdentifier];

    else if(details[SCNotificationCenterGrowlNotificationIdentifier])
        userInfo[SCNotificationCenterGrowlNotificationIdentifier] = details[SCNotificationCenterGrowlNotificationIdentifier];

    notification.userInfo = [userInfo copy];

    if(scheduledNotification)
        [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
    else
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)displayNotificationUsingGrowlWithDetails:(NSDictionary *)details{
    if(!details[SCNotificationCenterNotificationClickContext] && details[SCNotificationCenterNotificationUserInfo]){
        NSMutableDictionary *newDetails = [details mutableCopy];
        [newDetails setValue:details[SCNotificationCenterNotificationUserInfo] forKey:SCNotificationCenterNotificationClickContext];
        [GrowlApplicationBridge notifyWithDictionary:newDetails];
    }
    else{
        [GrowlApplicationBridge notifyWithDictionary:details];
    }
}

// This method automatically gets called when you change the notification method using setNotificationMethodPreference: Don't bother calling this method otherwise, hence why it's private.
- (void)updateNotificationMethod {
    if ([self getNotificationMethod] == SCNotificationCenterNotifyWithNotificationCenter && self.systemNotificationCenterAvailable)
        self.useSystemNotificationCenter = YES;
    else if ([self getNotificationMethod] == SCNotificationCenterNotifyWithNotificationCenter && !self.systemNotificationCenterAvailable)
        self.useSystemNotificationCenter = NO;
    else if ([self getNotificationMethod] == SCNotificationCenterNotifyWithGrowl)
        self.useSystemNotificationCenter = NO;
    else if ([self getNotificationMethod] == SCNotificationCenterNotifyByAvailability)
        self.useSystemNotificationCenter = self.systemNotificationCenterAvailable;
}

#pragma mark - NSUserDefaults Crap

+(void)initialize {
    NSDictionary *userDefaultsDict = @{@"SCNotificationMethod" : @(SCNotificationCenterNotifyByAvailability)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDict];
}

@end
