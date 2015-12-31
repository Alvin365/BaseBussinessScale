//
//  NSObject+KIAddition.m
//  Kitalker
//
//  Created by 杨 烽 on 12-10-24.
//  Copyright (c) 2012年 杨 烽. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+KIAdditions.h"
#import "NSData+KIAdditions.h"

NSString * const kPropertyList = @"kPropertyList";

@implementation NSObject (KIAdditions)

- (NSMutableArray *)attributeList {
    static NSMutableDictionary *classDictionary = nil;
    if (classDictionary == nil) {
        classDictionary = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass(self.class);
    
    NSMutableArray *propertyList = [classDictionary objectForKey:className];
    
    if (propertyList != nil) {
        return propertyList;
    }
    
    
//    NSMutableArray *propertyList = objc_getAssociatedObject(self, kPropertyList);
//    
//    if (propertyList != nil) {
//        return propertyList;
//    }
    
    propertyList = [[NSMutableArray alloc] init];
    
    id theClass = object_getClass(self);
    [self getPropertyList:theClass forList:&propertyList];
    
    [classDictionary setObject:propertyList forKey:className];
    
    
//    objc_setAssociatedObject(self, kPropertyList, propertyList, OBJC_ASSOCIATION_ASSIGN);
    
    return propertyList;
}

- (void)getPropertyList:(id)theClass forList:(NSMutableArray **)propertyList {
    id superClass = class_getSuperclass(theClass);
    unsigned int count, i;
    objc_property_t *properties = class_copyPropertyList(theClass, &count);
    for (i=0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        if (propertyName != nil) {
            [*propertyList addObject:propertyName];
            propertyName = nil;
        }
    }
    free(properties);
    
    if (superClass != [NSObject class]) {
        [self getPropertyList:superClass forList:propertyList];
    }
}

- (NSMutableDictionary *)keyAndValues {
    return [NSObject objectKeyValues:self];
}

+ (NSMutableDictionary *)objectKeyValues:(id)object {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *propertyList = [object attributeList];
    NSUInteger count = propertyList.count;
    
    NSString *propertyName = nil;
    
    for (int i=0; i<count; i++) {
        propertyName = [propertyList objectAtIndex:i];
        
        id propertyValue =[object valueForKey:propertyName];
        
        if (propertyValue == object) {
            continue;
        }
        
        if (propertyValue == nil) {
            propertyValue = @"";
        }
        
        if (![propertyValue isKindOfClass:[NSDictionary class]]
            && ![propertyValue isKindOfClass:[NSArray class]]
            && ![propertyValue isKindOfClass:[NSNumber class]]
            && ![propertyValue isKindOfClass:[NSString class]]
            && ![propertyValue isKindOfClass:[NSNull class]]) {
            
            [dictionary setObject:[NSObject objectKeyValues:propertyValue]
                      forKey:propertyName];
        } else {
            [dictionary setObject:propertyValue forKey:propertyName];
        }
    }
    return dictionary;
}

/*md5 加密*/
- (NSString *)md5 {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [data md5];
}

- (NSString *)appleLanguages {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
}

- (void)observeNotification:(NSString *)name {
    [self observeNotification:name selector:@selector(ki_handleNotification:)];
}

- (void)observeNotification:(NSString *)name selector:(SEL)selector {
    [self observeNotification:name selector:selector object:nil];
}

- (void)observeNotification:(NSString *)name selector:(SEL)selector object:(id)object {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:name
                                               object:object];
}

- (void)observeNotification:(NSString *)name block:(void (^)(NSNotification *noti))block {
    [self observeNotification:name queue:[NSOperationQueue mainQueue] block:block];
}

- (void)observeNotification:(NSString *)name queue:(NSOperationQueue *)queue block:(void (^)(NSNotification *noti))block {
    [self observeNotification:name object:nil queue:queue block:block];
}

- (void)observeNotification:(NSString *)name
                     object:(id)object
                      queue:(NSOperationQueue *)queue
                      block:(void (^)(NSNotification *note))block {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                      object:object
                                                       queue:queue
                                                  usingBlock:block];
}

- (void)unobserveNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotification:(NSString *)name {
    [self postNotification:name object:nil userInfo:nil];
}

- (void)postNotification:(NSString *)name withObject:(id)object {
    if (object == nil) {
        object = @"";
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:object forKey:kNotificationObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)postNotification:(NSString *)name userInfo:(NSDictionary *)userInfo {
    [self postNotification:name object:nil userInfo:userInfo];
}

- (void)postNotification:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:object
                                                      userInfo:userInfo];
}

- (void)ki_handleNotification:(NSNotification *)noti {
    if ([self respondsToSelector:@selector(handleNotification:object:userInfo:)]) {
        [self handleNotification:noti.name object:noti.object userInfo:noti.userInfo];
    } else if ([self respondsToSelector:@selector(handleNotification:withObject:)]) {
        [self handleNotification:noti.name withObject:[noti.userInfo objectForKey:kNotificationObject]];
    }
}

- (void)handleNotification:(NSString *)name withObject:(id)object {
    
}

- (void)handleNotification:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    
}

//键盘
- (void)observeKeyboardWillChangeNotification {
    [self observeNotification:UIKeyboardWillShowNotification selector:@selector(ki_keyboardWillShow:)];
    [self observeNotification:UIKeyboardWillHideNotification selector:@selector(ki_keyboardWillHide:)];
    [self observeNotification:UIKeyboardWillChangeFrameNotification selector:@selector(ki_keyboardWillShow:)];
}

- (void)unobserveKeyboardWillChangeNotification {
    [self unobserveNotification:UIKeyboardWillShowNotification];
    [self unobserveNotification:UIKeyboardWillHideNotification];
    [self unobserveNotification:UIKeyboardWillChangeFrameNotification];
}

- (void)ki_keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self changeKeyboardHeight:CGRectGetHeight(keyboardRect) animationDuration:animationDuration];
}

- (void)ki_keyboardWillHide:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self changeKeyboardHeight:0.0 animationDuration:animationDuration];
}

- (void)changeKeyboardHeight:(CGFloat)height animationDuration:(NSTimeInterval)duration {
    
}

- (void)observeApplicationWillTerminateNotification {
    [self observeNotification:UIApplicationWillTerminateNotification
                     selector:@selector(ki_applicationWillTerminateNotification:)];
}

- (void)unobserveApplicationWillTerminateNotification {
    [self unobserveNotification:UIApplicationWillTerminateNotification];
}

- (void)ki_applicationWillTerminateNotification:(NSNotification *)noti {
    UIApplication *application = [UIApplication sharedApplication];
    [self applicationWillTerminate:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (BOOL)isString {
    if ([self isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isArray {
    if ([self isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmptyArray {
    if (self != nil && [self isArray] && [(NSArray *)self count] > 0) {
        return NO;
    }
    return YES;
}

- (BOOL)isNotEmptyArray {
    if (self != nil && [self isArray] && [(NSArray *)self count] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isDictionary {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isNotEmptyDictionary {
    if ([self isDictionary]) {
        NSDictionary *tempDict = (NSDictionary *)self;
        if ([tempDict count] > 0) {
            return YES;
        }
    }
    return NO;
}

- (void)openURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (void)sendMail:(NSString *)mail {
    NSString *url = [NSString stringWithFormat:@"mailto://%@", mail];
    [self openURL:[NSURL URLWithString:url]];
}

- (void)sendSMS:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"sms://%@", number];
    [self openURL:[NSURL URLWithString:url]];
}

- (void)callNumber:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"tel://%@", number];
    [self openURL:[NSURL URLWithString:url]];
}

- (dispatch_source_t)createTimer:(dispatch_queue_t)queue
                        interval:(int)interval
                           block:(void(^)(NSUInteger count))block {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    __block NSUInteger totalTime = 0;
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval*NSEC_PER_MSEC, NSEC_PER_MSEC);
        dispatch_source_set_event_handler(timer, ^{
            block(totalTime);
            totalTime++;
        });
        dispatch_resume(timer);
    }
    return timer;
}

- (dispatch_source_t)createCountDownTimer:(dispatch_queue_t)queue
                                    total:(int)total
                                 interval:(int)interval
                                    block:(void(^)(int countDown))block {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    __block int totalTime = total;
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval*NSEC_PER_SEC, NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            if (totalTime >= 0) {
                block(totalTime);
                totalTime -= interval;
            } else {
                dispatch_source_cancel(timer);
            }
        });
        dispatch_resume(timer);
    }
    return timer;
}

@end
