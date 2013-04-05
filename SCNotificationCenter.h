//
//  SCNotificationCenter.h
//
//  Created by Alex Jackson on 26/07/2012.
//  Licensed under the Creative Commons Attribution 3.0 Unported License. http://creativecommons.org/licenses/by/3.0/
//

#import <Foundation/Foundation.h>
#import <Growl/Growl.h>
#import "SCNotificationCenterKeys.h"

@interface SCNotificationCenter : NSObject

typedef enum SCNotificationMethod : NSUInteger{
    SCNotificationCenterNotifyWithNotificationCenter = 0, // Notify exclusively using NSUserNotificationCenter
    SCNotificationCenterNotifyWithGrowl = 1, // Notify exclusively using Growl
    SCNotificationCenterNotifyByAvailability = 2 // Notify using whatever is available i.e. the default behaviour, NSUserNotification Center on OS 10.8 > and Growl on OS 10.7 <
} SCNotificationMethod;

+ (SCNotificationCenter *)sharedCenter;

// The keys for notification dictionaries can be found in SCNotificationCenterKeys.h.

- (void)notifyWithDictionary:(NSDictionary *)dictionary;
+ (void)notifyWithDictionary:(NSDictionary *)dictionary;

// Use these methods to specify what notification method to use, NSUserNotificationCenter, Growl or whichever of the two is available.

- (BOOL)setNotificationMethodPreference:(SCNotificationMethod)preference;
- (SCNotificationMethod)getNotificationMethod;

// Legacy Methods
// Avoid using these methods, they are here so that updating an app to use SCNotificationCenter can be easily done using a simple find and replace.
// Try to use the notifyWithDictionary: method since this will allow you to make use of features exclusive to NSUserNotification while maintaining backwards compatibility with Growl.

- (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
       notificationName:(NSString *)notifName
               iconData:(NSData *)iconData
               priority:(signed int)priority
               isSticky:(BOOL)isSticky
           clickContext:(id)clickContext
             identifier:(NSString *)indentifier;

- (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
       notificationName:(NSString *)notifName
               iconData:(NSData *)iconData
               priority:(signed int)priority
               isSticky:(BOOL)isSticky
           clickContext:(id)clickContext;

+ (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
       notificationName:(NSString *)notifName
               iconData:(NSData *)iconData
               priority:(signed int)priority
               isSticky:(BOOL)isSticky
           clickContext:(id)clickContext;

+ (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
       notificationName:(NSString *)notifName
               iconData:(NSData *)iconData
               priority:(signed int)priority
               isSticky:(BOOL)isSticky
           clickContext:(id)clickContext
             identifier:(NSString *)indentifier;

@property (readonly, assign) BOOL systemNotificationCenterAvailable; // SCNotificationCenter automatically determines whether to use Growl or NSUserNotification but you can use this property for other things if you are so inclined.
@property (assign) BOOL useSystemNotificationCenter;
@property (weak) id notificationCenterDelegate; //currently doesn't do anything.

@end
