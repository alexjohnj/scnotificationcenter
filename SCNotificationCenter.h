//
//  SCNotificationCenter.h
//  SymSteam
//
//  Created by Alex Jackson on 26/07/2012.
//
//

#import <Foundation/Foundation.h>
#import <Growl/Growl.h>
#import "SCNotificationCenterKeys.h"

@interface SCNotificationCenter : NSObject

+ (SCNotificationCenter *)sharedCenter;

// The keys for notification dictionaries can be found in SCNotificationCenterKeys.h.

- (void)notifyWithDictionary:(NSDictionary *)dictionary;
+ (void)notifyWithDictionary:(NSDictionary *)dictionary;

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

@property (assign) BOOL systemNotificationCenterAvailable;
@property (weak) id notificationCenterDelegate; //currently doesn't do anything. 

@end
