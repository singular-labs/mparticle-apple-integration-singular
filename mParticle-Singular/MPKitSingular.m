#import "MPKitSingular.h"
#import "Singular.h"

// This is temporary to allow compilation (will be provided by core SDK)
NSUInteger MPKitInstanceSingularTemp = 119;

@implementation MPKitSingular

@synthesize kitApi = _kitApi;

#define API_KEY @"apiKey"
#define SECRET_KEY @"secret"
#define DDL_TIMEOUT @"ddlTimeout"
#define TOTAL_PRODUCT_AMOUNT @"Total Product Amount"
#define USER_GENDER_MALE @"m"
#define USER_GENDER_FEMALE @"f"

NSString *appKey;
NSString *secret;
int ddlTimeout = 60;

/*
 mParticle will supply a unique kit code for you. Please contact our team
 */
+ (NSNumber *)kitCode {
    return @119;
}

+ (void)load {
    MPKitRegister *kitRegister = [[MPKitRegister alloc] initWithName:@"Singular" className:@"MPKitSingular"];
    [MParticle registerExtension:kitRegister];
}

#pragma mark - MPKitInstanceProtocol methods

#pragma mark Kit instance and lifecycle
- (MPKitExecStatus *)didFinishLaunchingWithConfiguration:(NSDictionary *)configuration {
    MPKitExecStatus *execStatus = nil;
    
    if(configuration[API_KEY] != nil)
        appKey = configuration[API_KEY];
    if(configuration[SECRET_KEY] != nil)
        secret = configuration[SECRET_KEY];
    if(configuration[DDL_TIMEOUT] != nil){
        ddlTimeout = [configuration[DDL_TIMEOUT] intValue];
        [Singular setDeferredDeepLinkTimeout:ddlTimeout];
    }
    
    if (!appKey) {
        execStatus = [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeRequirementsNotMet];
        return execStatus;
    }
    
    _configuration = configuration;
    
    [self start];
    
    execStatus = [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
    return execStatus;
}

- (void)start{
    static dispatch_once_t kitPredicate;
    dispatch_once(&kitPredicate, ^{
        /*
         Start your SDK here. The configuration dictionary can be retrieved from self.configuration
         */
        [Singular registerDeferredDeepLinkHandler:^(NSString *deeplink) {
            NSDictionary *ddlLink = [[NSDictionary alloc] initWithObjectsAndKeys:deeplink,SINGULAR_DEEPLINK_KEY, nil];
            
            MPAttributionResult *attributionResult = [[MPAttributionResult alloc] init];
            attributionResult.linkInfo = ddlLink;
            
            [self->_kitApi onAttributionCompleteWithResult:attributionResult error:nil];
        }];
        
        [Singular startSession:appKey withKey:secret];
        self->_started = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = @{mParticleKitInstanceKey:[[self class] kitCode]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:mParticleKitDidBecomeActiveNotification
                                                                object:nil
                                                              userInfo:userInfo];
        });
    });
}

- (id const)providerKitInstance {
    if (![self started]) {
        return nil;
    }
    /*
     If your company SDK instance is available and is applicable (Please return nil if your SDK is based on class methods)
     */
    BOOL kitInstanceAvailable = NO;
    if (kitInstanceAvailable) {
        /* Return an instance of your company's SDK (if applicable) */
        return nil;
    } else {
        return nil;
    }
}

#pragma mark Application
- (MPKitExecStatus *)setDeviceToken:(NSData *)deviceToken {
    [Singular registerDeviceTokenForUninstall:deviceToken];
    MPKitExecStatus *execStatus = [[MPKitExecStatus alloc] initWithSDKCode:@(MPKitInstanceSingularTemp) returnCode:MPKitReturnCodeSuccess];
    return execStatus;
}

/*
 Implement this method if your SDK handles continueUserActivity method from the App Delegate
 */
- (nonnull MPKitExecStatus *)continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(void(^ _Nonnull)(NSArray * _Nullable restorableObjects))restorationHandler {
    
    if([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]){
        [Singular registerDeferredDeepLinkHandler:^(NSString *deeplink) {
            NSDictionary *ddlLink = [[NSDictionary alloc] initWithObjectsAndKeys:deeplink,SINGULAR_DEEPLINK_KEY, nil];
            
            MPAttributionResult *attributionResult = [[MPAttributionResult alloc] init];
            attributionResult.linkInfo = ddlLink;
            
            [self->_kitApi onAttributionCompleteWithResult:attributionResult error:nil];
        }];
        
        NSURL *url = userActivity.webpageURL;
        [Singular startSession:appKey withKey:secret andLaunchURL:url];
    }
    MPKitExecStatus *execStatus = [[MPKitExecStatus alloc] initWithSDKCode:@(MPKitInstanceSingularTemp) returnCode:MPKitReturnCodeSuccess];
    return execStatus;
}


- (MPKitExecStatus *)setUserAttribute:(NSString *)key value:(NSString *)value {
    MPKitExecStatus *execStatus;
    if ([key isEqualToString:mParticleUserAttributeAge]) {
        NSInteger age = 0;
        @try {
            age = [value integerValue];
        } @catch (NSException *exception) {
            NSLog(@"mParticle -> Invalid age: %@", value);
            execStatus = [[MPKitExecStatus alloc] initWithSDKCode:@(MPKitInstanceSingularTemp) returnCode:MPKitReturnCodeFail];
            return execStatus;
        }
        [Singular setAge:[NSString stringWithFormat:@"%ld",(long)age]];
    }else if ([key isEqualToString:mParticleUserAttributeGender]) {
        [Singular setGender:mParticleGenderMale ? USER_GENDER_MALE : USER_GENDER_FEMALE];
    }
    execStatus = [[MPKitExecStatus alloc] initWithSDKCode:@(MPKitInstanceSingularTemp) returnCode:MPKitReturnCodeSuccess];
    return execStatus;
}

#pragma mark e-Commerce
- (MPKitExecStatus *)logCommerceEvent:(MPCommerceEvent *)commerceEvent {
    
    MPKitExecStatus *execStatus = [[MPKitExecStatus alloc] initWithSDKCode:@(MPKitInstanceSingularTemp) returnCode:MPKitReturnCodeSuccess forwardCount:0];
    
    if (commerceEvent.action == MPCommerceEventActionPurchase){
        NSMutableDictionary *baseProductAttributes = [[NSMutableDictionary alloc] init];
        NSDictionary *transactionAttributes = [commerceEvent.transactionAttributes beautifiedDictionaryRepresentation];
        
        if (transactionAttributes) {
            [baseProductAttributes addEntriesFromDictionary:transactionAttributes];
        }
        
        NSDictionary *commerceEventAttributes = [commerceEvent beautifiedAttributes];
        NSArray *keys = @[kMPExpCECheckoutOptions, kMPExpCECheckoutStep, kMPExpCEProductListName, kMPExpCEProductListSource];
        
        for (NSString *key in keys) {
            if (commerceEventAttributes[key]) {
                baseProductAttributes[key] = commerceEventAttributes[key];
            }
        }
        
        NSArray *products = commerceEvent.products;
        NSString *currency = commerceEvent.currency ? : @"USD";
        NSMutableDictionary *properties;
        
        for (MPProduct *product in products) {
            // Add relevant attributes from the commerce event
            properties = [[NSMutableDictionary alloc] init];
            if (baseProductAttributes.count > 0) {
                [properties addEntriesFromDictionary:baseProductAttributes];
            }
            
            // Add attributes from the product itself
            NSDictionary *productDictionary = [product beautifiedDictionaryRepresentation];
            if (productDictionary) {
                [properties addEntriesFromDictionary:productDictionary];
            }
            
            // Strips key/values already being passed to Appboy, plus key/values initialized to default values
            keys = @[kMPExpProductSKU, kMPProductCurrency, kMPExpProductUnitPrice, kMPExpProductQuantity, kMPProductAffiliation, kMPExpProductCategory, kMPExpProductName];
            [properties removeObjectsForKeys:keys];
            
            //get the amount
            NSNumber *totalProductAmount = nil;
            if(properties != nil && [properties valueForKey:TOTAL_PRODUCT_AMOUNT]){
                totalProductAmount = [properties valueForKey:TOTAL_PRODUCT_AMOUNT];
            }
            
            [Singular revenue:currency amount:[totalProductAmount doubleValue] productSKU:product.sku productName:product.name productCategory:product.category productQuantity:[product.quantity intValue] productPrice:[product.price doubleValue]];
            [execStatus incrementForwardCount];
        }
    }else{
        NSArray *expandedInstructions = [commerceEvent expandedInstructions];
        
        for (MPCommerceEventInstruction *commerceEventInstruction in expandedInstructions) {
            [self logEvent:commerceEventInstruction.event];
            [execStatus incrementForwardCount];
        }
    }
    return execStatus;
}

#pragma mark Events
- (MPKitExecStatus *)logEvent:(MPEvent *)event {
    if (event.info.count > 0) {
        [Singular event:event.name withArgs:event.info];
    } else {
        [Singular event:event.name];
    }
    MPKitExecStatus *execStatus = [[MPKitExecStatus alloc] initWithSDKCode:@(MPKitInstanceSingularTemp) returnCode:MPKitReturnCodeSuccess];
    return execStatus;
}

- (nonnull MPKitExecStatus *)openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nullable id)annotation {
    if(url){
        [Singular registerDeferredDeepLinkHandler:^(NSString *deeplink) {
            NSDictionary *ddlLink = [[NSDictionary alloc] initWithObjectsAndKeys:deeplink,SINGULAR_DEEPLINK_KEY, nil];
            
            MPAttributionResult *attributionResult = [[MPAttributionResult alloc] init];
            attributionResult.linkInfo = ddlLink;
            
            [self->_kitApi onAttributionCompleteWithResult:attributionResult error:nil];
        }];
        
        [Singular startSession:appKey withKey:secret andLaunchURL:url];
    }
    MPKitExecStatus *execStatus = [[MPKitExecStatus alloc] initWithSDKCode:@(MPKitInstanceBranchMetrics) returnCode:MPKitReturnCodeSuccess];
    return execStatus;
}

- (nonnull MPKitExecStatus *)openURL:(nonnull NSURL *)url options:(nullable NSDictionary<NSString *, id> *)options {
    if(url){
        [Singular registerDeferredDeepLinkHandler:^(NSString *deeplink) {
            NSDictionary *ddlLink = [[NSDictionary alloc] initWithObjectsAndKeys:deeplink,SINGULAR_DEEPLINK_KEY, nil];
            
            
            MPAttributionResult *attributionResult = [[MPAttributionResult alloc] init];
            attributionResult.linkInfo = ddlLink;
            
            [self->_kitApi onAttributionCompleteWithResult:attributionResult error:nil];
        }];
        
        [Singular startSession:appKey withKey:secret andLaunchURL:url];
    }
    MPKitExecStatus *execStatus = [[MPKitExecStatus alloc] initWithSDKCode:@(MPKitInstanceSingularTemp) returnCode:MPKitReturnCodeSuccess];
    return execStatus;
}

@end
