//
//  NSObject+extra.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "NSObject+extra.h"

@implementation NSObject (extra)

+ (Class)viewClass
{
    NSString *className = [NSStringFromClass([self class]) stringByAppendingString:@"View"];
    id viewClass = NSClassFromString(className);
    return viewClass;
}

+ (Class)firstViewClass
{
    id viewClass = self.class.viewClass;
    
    if (viewClass)
    {
        return viewClass;
    }
    
    if (self.superclass)
    {
        return self.superclass.firstViewClass;
    }
    
    return nil;
}

- (id)idNoWarningPerformSelector:(SEL)aSelector
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id result = [self performSelector:aSelector];
#pragma clang diagnostic pop
    return result;
}


- (void)noWarningPerformSelector:(SEL)aSelector
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:aSelector];
    #pragma clang diagnostic pop
}


- (void)noWarningPerformSelector:(SEL)aSelector withObject:anArgument
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:aSelector withObject:anArgument];
    #pragma clang diagnostic pop
}

- (void)voidPerformSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:aSelector];
    [inv invoke];
}

- (void)voidPerformSelector:(SEL)aSelector withObject:(id)aValue
{
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    
    assert(sig.numberOfArguments - 2 == 1); // first 2 args or self and cmd
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:aSelector];
    [inv setArgument:&aValue atIndex:2 + 0];

    id arg0;
    [inv getArgument:&arg0 atIndex:0];
    IMP cmd;
    [inv getArgument:&cmd atIndex:1];
    id v;
    [inv getArgument:&v atIndex:2];
    
    [inv retainArguments];
    [inv invoke];
}

- (BOOL)boolPerformSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];

    assert(strcmp([sig methodReturnType], @encode(BOOL)) == 0);

    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:aSelector];
    [inv retainArguments];
    [inv invoke];
    BOOL result = NO;
    [inv getReturnValue:&result];
    return result;
}

- (id)idPerformSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    
    assert(strcmp([sig methodReturnType], @encode(id)) == 0);
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:aSelector];
    [inv retainArguments];
    [inv invoke];
    id __unsafe_unretained result = nil;
    [inv getReturnValue:&result];
    return result;
}

- (NSInteger)nsintegerPerformSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    
    assert(strcmp([sig methodReturnType], @encode(NSInteger)) == 0);
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv retainArguments];
    [inv invoke];
    NSInteger result = 0;
    [inv getReturnValue:&result];
    return result;
}

@end
