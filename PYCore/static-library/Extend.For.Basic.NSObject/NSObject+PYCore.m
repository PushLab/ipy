//
//  NSObject+PYCore.m
//  PYCore
//
//  Created by Push Chen on 3/31/13.
//  Copyright (c) 2013 PushLab. All rights reserved.
//

/*
 LISENCE FOR IPY
 COPYRIGHT (c) 2013, Push Chen.
 ALL RIGHTS RESERVED.
 
 REDISTRIBUTION AND USE IN SOURCE AND BINARY
 FORMS, WITH OR WITHOUT MODIFICATION, ARE
 PERMITTED PROVIDED THAT THE FOLLOWING CONDITIONS
 ARE MET:
 
 YOU USE IT, AND YOU JUST USE IT!.
 WHY NOT USE THIS LIBRARY IN YOUR CODE TO MAKE
 THE DEVELOPMENT HAPPIER!
 ENJOY YOUR LIFE AND BE FAR AWAY FROM BUGS.
 */

#import "NSObject+PYCore.h"
#import <objc/message.h>

#define SuppressPerformSelectorLeakWarning(Stuff)                       \
do {                                                                    \
    _Pragma("clang diagnostic push")                                    \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff;                                                              \
    _Pragma("clang diagnostic pop")                                     \
} while (0)

@implementation NSObject (PYCore)

/* Raise an exception and throw the message specifed. */
- (void)raiseExceptionWithMessage:(NSString *)message
{
    NSException *e = [NSException exceptionWithName:NSStringFromClass([self class])
                                             reason:[message copy]
                                           userInfo:nil];
    @throw e;
}
+ (void)raiseExceptionWithMessage:(NSString *)message
{
    NSException *e = [NSException exceptionWithName:NSStringFromClass([self class])
                                             reason:[message copy]
                                           userInfo:nil];
    @throw e;
}

/* Create a NSError object with message */
- (NSError *)errorWithCode:(int)code message:(NSString *)message
{
    if ( message == nil || [message isEqual:[NSNull null]] ) message = @"";
    NSDictionary *_errMsg = @{NSLocalizedDescriptionKey:message};
    NSError *_error = [NSError errorWithDomain:NSStringFromClass([self class])
                                          code:code
                                      userInfo:_errMsg];
    return _error;
}
+ (NSError *)errorWithCode:(int)code message:(NSString *)message
{
    if ( message == nil || [message isEqual:[NSNull null]] ) message = @"";
    NSDictionary *_errMsg = @{NSLocalizedDescriptionKey:message};
    NSError *_error = [NSError errorWithDomain:NSStringFromClass([self class])
                                          code:code
                                      userInfo:_errMsg];
    return _error;
}

/* return an autorelease object */
+ (id)object
{
#if __has_feature(objc_arc)
    return [[self alloc] init];
#else
    return [[[self alloc] init] autorelease];
#endif
}

/* Increase the reference count in Non-ARC mode, or do nothing */
- (id)increaseRC
{
#if __has_feature(objc_arc)
    return self;
#else
    return [self retain];
#endif
}

/* Decrease the reference count in Non-ARC mode, or do nothing */
- (void)decreaseRC
{
#if __has_feature(objc_arc)
    // Nothing
#else
    [self release];
#endif
}

// For Delegated object, try to perform selector
- (id)tryPerformSelector:(SEL)sel
{
    // check if is a nil invoking
    if ( self == nil || sel == nil ) return nil;
    
    Method _m = class_getInstanceMethod([self class], sel);
    if ( _m == NULL ) return nil;
    struct objc_method_description *_mDesc = method_getDescription(_m);
    if ( _mDesc == NULL ) return nil;
    NSMethodSignature *_methodSig = [NSMethodSignature signatureWithObjCTypes:_mDesc->types];
    NSInvocation *_invocation = [NSInvocation invocationWithMethodSignature:_methodSig];
    NSInteger _argumentCount = [_methodSig numberOfArguments];
    [_invocation setSelector:sel];
    [_invocation setTarget:self];
    
    __weak NSObject *_dump = self;
    if ( _argumentCount > 2 ) {
        for ( int i = 2; i < _argumentCount; ++i ) {
            [_invocation setArgument:&_dump atIndex:i];
        }
    }
    [_invocation retainArguments];
    [_invocation invoke];

    char _rType[32] = {0};
    method_getReturnType(_m, _rType, 32);
    if ( strcmp(_rType, "v") == 0 ) {
        return nil;
    }
    
    id _returnObject;
    [_invocation getReturnValue:&_returnObject];
    return _returnObject;
    
//    _Pragma("clang diagnostic push")
//    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
//    id _r = [self performSelector:sel];
//    _Pragma("clang diagnostic pop")
//    
//    return _r;
    
//    // Get the return type
//    id (*__msg_send)(id, SEL) = (id (*)(id, SEL))objc_msgSend;
//    char _rType[32] = {0};
//    method_getReturnType(_m, _rType, 32);
//    if ( strcmp(_rType, "v") == 0 ) {
//        __msg_send(self, sel);
//    } else {
//        return __msg_send(self, sel);
//    }
//    return nil;
}
- (id)tryPerformSelector:(SEL)sel withObject:(id)object
{
    // check if is a nil invoking
    if ( self == nil || sel == nil ) return nil;
    
    Method _m = class_getInstanceMethod([self class], sel);
    if ( _m == NULL ) return nil;
    struct objc_method_description *_mDesc = method_getDescription(_m);
    if ( _mDesc == NULL ) return nil;
    NSMethodSignature *_methodSig = [NSMethodSignature signatureWithObjCTypes:_mDesc->types];
    NSInvocation *_invocation = [NSInvocation invocationWithMethodSignature:_methodSig];
    NSInteger _argumentCount = [_methodSig numberOfArguments];
    [_invocation setSelector:sel];
    [_invocation setTarget:self];
    
    [_invocation setArgument:&object atIndex:2];
    
    __weak NSObject *_dump = self;
    if ( _argumentCount > 3 ) {
        for ( int i = 3; i < _argumentCount; ++i ) {
            [_invocation setArgument:&_dump atIndex:i];
        }
    }
    [_invocation retainArguments];
    [_invocation invoke];
    
    char _rType[32] = {0};
    method_getReturnType(_m, _rType, 32);
    if ( strcmp(_rType, "v") == 0 ) {
        return nil;
    }
    
    id _returnObject;
    [_invocation getReturnValue:&_returnObject];
    return _returnObject;

//    _Pragma("clang diagnostic push")
//    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
//    id _r = [self performSelector:sel withObject:object];
//    _Pragma("clang diagnostic pop")
//
//    return _r;

//    // Get the return type
//    id (*__msg_send)(id, SEL, id) = (id (*)(id, SEL, id))objc_msgSend;
//    char _rType[32] = {0};
//    method_getReturnType(_m, _rType, 32);
//    if ( strcmp(_rType, "v") == 0 ) {
//        __msg_send(self, sel, object);
//    } else {
//        return __msg_send(self, sel, object);
//    }
//    return nil;
}
- (id)tryPerformSelector:(SEL)sel withObject:(id)obj1 withObject:(id)obj2
{
    // check if is a nil invoking
    if ( self == nil || sel == nil ) return nil;
    
    Method _m = class_getInstanceMethod([self class], sel);
    if ( _m == NULL ) return nil;
    
    struct objc_method_description *_mDesc = method_getDescription(_m);
    if ( _mDesc == NULL ) return nil;
    NSMethodSignature *_methodSig = [NSMethodSignature signatureWithObjCTypes:_mDesc->types];
    NSInvocation *_invocation = [NSInvocation invocationWithMethodSignature:_methodSig];
    NSInteger _argumentCount = [_methodSig numberOfArguments];
    [_invocation setSelector:sel];
    [_invocation setTarget:self];
    [_invocation setArgument:&obj1 atIndex:2];
    [_invocation setArgument:&obj2 atIndex:3];
    
    __weak NSObject *_dump = self;
    if ( _argumentCount > 4 ) {
        for ( int i = 4; i < _argumentCount; ++i ) {
            [_invocation setArgument:&_dump atIndex:i];
        }
    }
    [_invocation retainArguments];
    [_invocation invoke];
    
    char _rType[32] = {0};
    method_getReturnType(_m, _rType, 32);
    if ( strcmp(_rType, "v") == 0 ) {
        return nil;
    }
    
    id _returnObject;
    [_invocation getReturnValue:&_returnObject];
    return _returnObject;

//    _Pragma("clang diagnostic push")
//    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
//    id _r = [self performSelector:sel withObject:obj1 withObject:obj2];
//    _Pragma("clang diagnostic pop")
//
//    return _r;

//    // Get the return type
//    id (*__msg_send)(id, SEL, id, id) = (id (*)(id, SEL, id, id))objc_msgSend;
//    char _rType[32] = {0};
//    method_getReturnType(_m, _rType, 32);
//    if ( strcmp(_rType, "v") == 0 ) {
//        __msg_send(self, sel, obj1, obj2);
//    } else {
//        return __msg_send(self, sel, obj1, obj2);
//    }
//    return nil;
}
- (void)_backgroundBlockInvocationSelector:(void(^)())block
{
    if ( block ) block();
}
- (void)performBlockInBackground:(void (^)())block
{
    [self
     performSelectorInBackground:@selector(_backgroundBlockInvocationSelector:)
     withObject:block];
}

// The object must be a certain type, or throw an exception.
- (void)mustBeTypeOrFailed:(Class)type
{
    if ( [self isKindOfClass:type] ) return;
    [self raiseExceptionWithMessage:
     [NSString stringWithFormat:@"You may want me to be %@, but I am %@",
      NSStringFromClass(type), NSStringFromClass([self class])]];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
