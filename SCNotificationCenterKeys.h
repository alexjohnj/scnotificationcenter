//
//  SCNotificationCenterKeys.h
//
//  Created by Alex Jackson on 26/07/2012.
//  Licensed under the Creative Commons Attribution 3.0 Unported License. http://creativecommons.org/licenses/by/3.0/
//

#import <Foundation/Foundation.h>

//  A human readable name for the notification that must be declared in the Growl notification dictionary. You must add this key in order for the notification to work with Growl. Has no effect with NSUserNotificationCenter.
extern NSString * const SCNotificationCenterNotificationName;

// A title displayed in the notification. The same as Growl's `NotificationName` key and the same as NSUserNotification's `title` property.
extern NSString * const SCNotificationCenterNotificationTitle;

// A description displayed in the notification. The same as Growl's `NotificationDescription` key and the same as NSUserNotification's `informativeText` property.
extern NSString * const SCNotificationCenterNotificationDescription;

// An NSData object displayed as an icon with a Growl notification. The same as Growl's `NotificationIcon` key. There's no equivalent for NSUserNotificationCenter and it will be ignored.
extern NSString * const SCNotificationCenterNotificationIcon;

// Pretty much the same as above. The equivalent to Growl's `NotificationAppIcon` key.
extern NSString * const SCNotificationCenterNotificationAppIcon;

// An integer between -2 & 2 indicating the priority of the notification. The same as Growl's `NotificationPriority` key. There's no equivalent for NSUserNotificationCenter and it will be ignored. 
extern NSString * const SCNotificationCenterNotificationPriority;

// A boolean indicating if the notification should disappear after a certain amount of time. The same as Growl's `NotificationSticky` key. No equivalent for NSUserNotificationCenter and it will be ignored.
extern NSString * const SCNotificationCenterNotificationSticky;

// A plist-encodable object that is unique to a notification and is provided as a parameter in Growl notification callbacks. The same as Growl's `NotificationClickContext`. For NSUserNotifications, it will be placed in the userInfo dictionary under the same key.
// The object MUST be plist-encodable because NSUserNotification's userInfo dictionary must be. If it isn't, an exception will be thrown. In addition, the object must be < 1k in size otherwise an exception will be thrown.
extern NSString * const SCNotificationCenterNotificationClickContext;

//  An identifier for the notification. Must be a string. The same as `GrowlNotificationIdentifier` for Growl. For NSUserNotifications it will be placed in the userInfo dictionary under the key `GrowlNotificationIdentifier`.
extern NSString * const SCNotificationCenterNotificationIdentifier;
extern NSString * const SCNotificationCenterGrowlNotificationIdentifier;

// A subtitle displayed with the notification. Used as NSUserNotification's `subtitle` property. There's no equivalent in Growl so this key will be ignored.
extern NSString * const SCNotificationCenterNotificationSubtitle;

// Boolean value indicating if the notification has an action button attached to it. Only available with NSUserNotifications. Will be ignored by Growl.
extern NSString * const SCNotificationCenterNotificationHasActionButton;

// A title for an action button on a notification. Only available with NSUserNotifications. Will be ignored by Growl.
extern NSString * const SCNotificationCenterNotificationActionButtonTitle;

// An NSDate indicating when the notification should be displayed. Sets the `deliveryDate` property for NSUserNotifications. There's no equivalent for Growl so it's ignored.
extern NSString * const SCNotificationCenterNotificationDeliveryDate;

// An NSDictionary containing plist-encodable objects that is attached to a notification. The object is made available in notification callbacks. For NSUserNotifications, the dictionary is assigned to the `userInfo` property. For Growl, the dictionary is assigned to the notification's `clickContext`.
extern NSString * const SCNotificationCenterNotificationUserInfo;

// An NSString that is the name of a sound that is played when the notification is displayed. Used as NSUserNotification's `soundName` key. Ignored by Growl. 
extern NSString * const SCNotificationCenterNotificationSound;
