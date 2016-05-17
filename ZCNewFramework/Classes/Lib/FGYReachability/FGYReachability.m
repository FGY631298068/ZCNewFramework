/*
 
 File: Reachability.m
 Abstract: Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 
 Version: 2.0.4ddg
 */

/*
 Significant additions made by Andrew W. Donoho, August 11, 2009.
 This is a derived work of Apple's Reachability v2.0 class.
 
 The below license is the new BSD license with the OSI recommended personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>

 Extensions Copyright (C) 2009 Donoho Design Group, LLC. All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Andrew W. Donoho nor Donoho Design Group, L.L.C.
 may be used to endorse or promote products derived from this software
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY DONOHO DESIGN GROUP, L.L.C. "AS IS" AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */


/*
 
 Apple's Original License on Reachability v2.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.

 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
*/

/*
 Each reachability object now has a copy of the key used to store it in a dictionary.
 This allows each observer to quickly determine if the event is important to them.
*/

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>

#import "FGYReachability.h"

NSString *const yckInternetConnection  = @"InternetConnection";
NSString *const yckLocalWiFiConnection = @"LocalWiFiConnection";
NSString *const yckReachabilityChangedNotification = @"NetworkReachabilityChangedNotification";

#define CLASS_DEBUG 1 // Turn on logReachabilityFlags. Must also have a project wide defined DEBUG.

#if (defined DEBUG && defined CLASS_DEBUG)
#define yclogReachabilityFlags(flags) (yclogReachabilityFlags_(__PRETTY_FUNCTION__, __LINE__, flags))

static NSString *ycreachabilityFlags_(SCNetworkReachabilityFlags flags) {
	
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) // Apple advises you to use the magic number instead of a symbol.
    return [NSString stringWithFormat:@"Reachability Flags: %c%c %c%c%c%c%c%c%c",
			(flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
			(flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
			
			(flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
			(flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
			(flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
			(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
			(flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
			(flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
			(flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
#else
	// Compile out the v3.0 features for v2.2.1 deployment.
    return [NSString stringWithFormat:@"Reachability Flags: %c%c %c%c%c%c%c%c",
			(flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
			(flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
			
			(flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
			(flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
			(flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
			// v3 kSCNetworkReachabilityFlagsConnectionOnTraffic == v2 kSCNetworkReachabilityFlagsConnectionAutomatic
			(flags & kSCNetworkReachabilityFlagsConnectionAutomatic)  ? 'C' : '-',
			// (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-', // No v2 equivalent.
			(flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
			(flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
#endif
	
} // reachabilityFlags_()

static void yclogReachabilityFlags_(const char *name, int line, SCNetworkReachabilityFlags flags) {
	
    NSLog(@"%s (%d) \n\t%@", name, line, ycreachabilityFlags_(flags));
	
} // logReachabilityFlags_()

#define yclogNetworkStatus(status) (yclogNetworkStatus_(__PRETTY_FUNCTION__, __LINE__, status))

static void yclogNetworkStatus_(const char *name, int line, YCNetworkStatus status) {
	
	NSString *statusString = nil;
	
	switch (status) {
		case YCNotReachable:
			statusString = @"Not Reachable";
			break;
		case YCReachableViaWWAN:
			statusString = @"Reachable via WWAN";
			break;
		case YCReachableViaWiFi:
			statusString = @"Reachable via WiFi";
			break;
	}
	
	NSLog(@"%s (%d) \n\tNetwork Status: %@", name, line, statusString);
	
} // logNetworkStatus_()

#else
#define yclogReachabilityFlags(flags)
#define yclogNetworkStatus(status)
#endif

@interface FGYReachability (private)

- (YCNetworkStatus) networkStatusForFlagss: (SCNetworkReachabilityFlags) flags;

@end

@implementation FGYReachability

@synthesize key = key_;

// Preclude direct access to ivars.
+ (BOOL) accessInstanceVariablesDirectly {
	
	return NO;

} // accessInstanceVariablesDirectly


- (void) dealloc {
	
	[self ycstopNotifier];
	if(ycreachabilityRef) {
		
		CFRelease(ycreachabilityRef); ycreachabilityRef = NULL;
		
	}
	
	self.key = nil;
	
	//[super dealloc];
	
} // dealloc


- (FGYReachability *) initWithReachabilityRef: (SCNetworkReachabilityRef) ref
{
    self = [super init];
	if (self != nil) 
    {
		ycreachabilityRef = ref;
	}
	
	return self;
	
} // initWithReachabilityRef:


#if (defined DEBUG && defined CLASS_DEBUG)
- (NSString *) description {
	
	NSAssert(ycreachabilityRef, @"-description called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	
	SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags);
	
	return [NSString stringWithFormat: @"%@\n\t%@", self.key, ycreachabilityFlags_(flags)];
	
} // description
#endif


#pragma mark -
#pragma mark Notification Management Methods


//Start listening for reachability notifications on the current run loop
static void YCReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {

	#pragma unused (target, flags)
	NSCAssert(info, @"info was NULL in ReachabilityCallback");
	//NSCAssert([(NSObject*) CFBridgingRelease(info isKindOfClass: [Reachability class]], @"info was the wrong class in ReachabilityCallback");
	
	//We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
	// in case someone uses the Reachablity object in a different thread.
	//NSAutoreleasePool* pool = [NSAutoreleasePool new];
	
	// Post a notification to notify the client that the network reachability changed.
	[[NSNotificationCenter defaultCenter] postNotificationName: yckReachabilityChangedNotification 
														object: (__bridge FGYReachability *) info];
	
	//[pool release];

} // ReachabilityCallback()


- (BOOL) ycstartNotifier {
	
	SCNetworkReachabilityContext	contexts = {0, (__bridge void * _Nullable)(self), NULL, NULL, NULL};
	
	if(SCNetworkReachabilitySetCallback(ycreachabilityRef, YCReachabilityCallback, &contexts)) {
		
		if(SCNetworkReachabilityScheduleWithRunLoop(ycreachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {

			return YES;
			
		}
		
	}
	
	return NO;

} // startNotifier


- (void) ycstopNotifier {
	
	if(ycreachabilityRef) {
		
		SCNetworkReachabilityUnscheduleFromRunLoop(ycreachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

	}

} // stopNotifier


- (BOOL) ycisEqual: (FGYReachability *) r {
	
	return [r.key isEqualToString: self.key];
	
} // isEqual:


//#pragma mark -
//#pragma mark Reachability Allocation Methods


+ (FGYReachability *) reachabilityWithHostName: (NSString *) hostName {
	
	SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	
	if (ref) {
		
		FGYReachability *r = [[self alloc] initWithReachabilityRef: ref] ;
		
		r.key = hostName;

		return r;
		
	}
	
	return nil;
	
} // reachabilityWithHostName


+ (NSString *) makeAddressKey: (in_addr_t) addr {
	// addr is assumed to be in network byte order.
	
	static const int       ychighShift    = 24;
	static const int       ychighMidShift = 16;
	static const int       yclowMidShift  =  8;
	static const in_addr_t masks         = 0x000000ff;
	
	addr = ntohl(addr);
	
	return [NSString stringWithFormat: @"%d.%d.%d.%d", 
			(addr >> ychighShift)    & masks,
			(addr >> ychighMidShift) & masks,
			(addr >> yclowMidShift)  & masks,
			 addr                  & masks];
	
} // makeAddressKey:


+ (FGYReachability *) reachabilityWithAddress: (const struct sockaddr_in *) hostAddress {
	
	SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);

	if (ref) {
		
		FGYReachability *r = [[self alloc] initWithReachabilityRef: ref] ;
		
		r.key = [self makeAddressKey: hostAddress->sin_addr.s_addr];
		
		return r;
		
	}
	
	return nil;

} // reachabilityWithAddress


+ (FGYReachability *) reachabilityForInternetConnection {
	
	struct sockaddr_in zeroAddresss;
	bzero(&zeroAddresss, sizeof(zeroAddresss));
	zeroAddresss.sin_len = sizeof(zeroAddresss);
	zeroAddresss.sin_family = AF_INET;

	FGYReachability *r = [self reachabilityWithAddress: &zeroAddresss];

	r.key = yckInternetConnection;
	
	return r;

} // reachabilityForInternetConnection


+ (FGYReachability *) reachabilityForLocalWiFi {
	
	struct sockaddr_in localWifiAddresss;
	bzero(&localWifiAddresss, sizeof(localWifiAddresss));
	localWifiAddresss.sin_len = sizeof(localWifiAddresss);
	localWifiAddresss.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddresss.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);

	FGYReachability *r = [self reachabilityWithAddress: &localWifiAddresss];

	r.key = yckLocalWiFiConnection;

	return r;

} // reachabilityForLocalWiFi


//#pragma mark -
//#pragma mark Network Flag Handling Methods


#if USE_DDG_EXTENSIONS
//
// iPhone condition codes as reported by a 3GS running iPhone OS v3.0.
// Airplane Mode turned on:  Reachability Flag Status: -- -------
// WWAN Active:              Reachability Flag Status: WR -t-----
// WWAN Connection required: Reachability Flag Status: WR ct-----
//         WiFi turned on:   Reachability Flag Status: -R ------- Reachable.
// Local   WiFi turned on:   Reachability Flag Status: -R xxxxxxd Reachable.
//         WiFi turned on:   Reachability Flag Status: -R ct----- Connection down. (Non-intuitive, empirically determined answer.)
const SCNetworkReachabilityFlags yckConnectionDown =  kSCNetworkReachabilityFlagsConnectionRequired |
												    kSCNetworkReachabilityFlagsTransientConnection;
//         WiFi turned on:   Reachability Flag Status: -R ct-i--- Reachable but it will require user intervention (e.g. enter a WiFi password).
//         WiFi turned on:   Reachability Flag Status: -R -t----- Reachable via VPN.
//
// In the below method, an 'x' in the flag status means I don't care about its value.
//
// This method differs from Apple's by testing explicitly for empirically observed values.
// This gives me more confidence in it's correct behavior. Apple's code covers more cases 
// than mine. My code covers the cases that occur.
//
- (YCNetworkStatus) networkStatusForFlagss: (SCNetworkReachabilityFlags) flags {
	
	if (flags & kSCNetworkReachabilityFlagsReachable) {
		
		// Local WiFi -- Test derived from Apple's code: -localWiFiStatusForFlags:.
		if (self.key == yckLocalWiFiConnection) {

			// Reachability Flag Status: xR xxxxxxd Reachable.
			return (flags & kSCNetworkReachabilityFlagsIsDirect) ? yckReachableViaWiFi : YCNotReachable;

		}
		
		// Observed WWAN Values:
		// WWAN Active:              Reachability Flag Status: WR -t-----
		// WWAN Connection required: Reachability Flag Status: WR ct-----
		//
		// Test Value: Reachability Flag Status: WR xxxxxxx
		if (flags & kSCNetworkReachabilityFlagsIsWWAN) { return YCReachableViaWWAN; }
		
		// Clear moot bits.
		flags &= ~kSCNetworkReachabilityFlagsReachable;
		flags &= ~kSCNetworkReachabilityFlagsIsDirect;
		flags &= ~kSCNetworkReachabilityFlagsIsLocalAddress; // kInternetConnection is local.
		
		// Reachability Flag Status: -R ct---xx Connection down.
		if (flags == yckConnectionDown) { return YCNotReachable; }
		
		// Reachability Flag Status: -R -t---xx Reachable. WiFi + VPN(is up) (Thank you Ling Wang)
		if (flags & kSCNetworkReachabilityFlagsTransientConnection)  { return yckReachableViaWiFi; }
			
		// Reachability Flag Status: -R -----xx Reachable.
		if (flags == 0) { return yckReachableViaWiFi; }
		
		// Apple's code tests for dynamic connection types here. I don't. 
		// If a connection is required, regardless of whether it is on demand or not, it is a WiFi connection.
		// If you care whether a connection needs to be brought up,   use -isConnectionRequired.
		// If you care about whether user intervention is necessary,  use -isInterventionRequired.
		// If you care about dynamically establishing the connection, use -isConnectionIsOnDemand.

		// Reachability Flag Status: -R cxxxxxx Reachable.
		if (flags & kSCNetworkReachabilityFlagsConnectionRequired) { return yckReachableViaWiFi; }
		
		// Required by the compiler. Should never get here. Default to not connected.
#if (defined DEBUG && defined CLASS_DEBUG)
		NSAssert1(NO, @"Uncaught reachability test. Flags: %@", ycreachabilityFlags_(flags));
#endif
		return YCNotReachable;

		}
	
	// Reachability Flag Status: x- xxxxxxx
	return YCNotReachable;
	
} // networkStatusForFlags:


- (YCNetworkStatus) yccurrentReachabilityStatus {
	
	NSAssert(ycreachabilityRef, @"currentReachabilityStatus called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	YCNetworkStatus status = YCNotReachable;
	
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags)) {
		
//		logReachabilityFlags(flags);
		
		status = [self networkStatusForFlagss: flags];
		
		return status;
		
	}
	
	return YCNotReachable;
	
} // currentReachabilityStatus


- (BOOL) ycisReachable {
	
	NSAssert(ycreachabilityRef, @"isReachable called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	YCNetworkStatus status = YCNotReachable;
	
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags)) {
		
//		logReachabilityFlags(flags);

		status = [self networkStatusForFlagss: flags];

//		logNetworkStatus(status);
		
		return (YCNotReachable != status);
		
	}
	
	return NO;
	
} // isReachable


- (BOOL) ycisConnectionRequired {
	
	NSAssert(ycreachabilityRef, @"isConnectionRequired called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags)) {
		
		yclogReachabilityFlags(flags);
		
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);

	}
	
	return NO;
	
} // isConnectionRequired


- (BOOL) ycconnectionRequired {
	
	return [self ycisConnectionRequired];
	
} // connectionRequired
#endif


#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000)
static const SCNetworkReachabilityFlags yckOnDemandConnection = kSCNetworkReachabilityFlagsConnectionOnTraffic |
                                                              kSCNetworkReachabilityFlagsConnectionOnDemand;
#else
static const SCNetworkReachabilityFlags yckOnDemandConnection = kSCNetworkReachabilityFlagsConnectionAutomatic;
#endif

- (BOOL) ycisConnectionOnDemand {
	
	NSAssert(ycreachabilityRef, @"isConnectionIsOnDemand called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags)) {
		
		yclogReachabilityFlags(flags);
		
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & yckOnDemandConnection));
		
	}
	
	return NO;
	
} // isConnectionOnDemand


- (BOOL) ycisInterventionRequired {
	
	NSAssert(ycreachabilityRef, @"isInterventionRequired called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags)) {
		
		yclogReachabilityFlags(flags);
		
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & kSCNetworkReachabilityFlagsInterventionRequired));
		
	}
	
	return NO;
	
} // isInterventionRequired


- (BOOL) ycisReachableViaWWAN {
	
	NSAssert(ycreachabilityRef, @"isReachableViaWWAN called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	YCNetworkStatus status = YCNotReachable;
	
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags)) {
		
		yclogReachabilityFlags(flags);
		
		status = [self networkStatusForFlagss: flags];
		
		return  (yckReachableViaWWAN == status);
			
	}
	
	return NO;
	
} // isReachableViaWWAN


- (BOOL) ycisReachableViaWiFi {
	
	NSAssert(ycreachabilityRef, @"isReachableViaWiFi called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	YCNetworkStatus status = YCNotReachable;
	
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags)) {
		
		yclogReachabilityFlags(flags);
		
		status = [self networkStatusForFlagss: flags];
		
		return  (yckReachableViaWiFi == status);
		
	}
	
	return NO;
	
} // isReachableViaWiFi


- (SCNetworkReachabilityFlags) ycreachabilityFlags {
	
	NSAssert(ycreachabilityRef, @"reachabilityFlags called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags)) {
		
		yclogReachabilityFlags(flags);
		
		return flags;
		
	}
	
	return 0;
	
} // reachabilityFlags


//#pragma mark -
//#pragma mark Apple's Network Flag Handling Methods


#if !USE_DDG_EXTENSIONS
/*
 *
 *  Apple's Network Status testing code.
 *  The only changes that have been made are to use the new logReachabilityFlags macro and
 *  test for local WiFi via the key instead of Apple's boolean. Also, Apple's code was for v3.0 only
 *  iPhone OS. v2.2.1 and earlier conditional compiling is turned on. Hence, to mirror Apple's behavior,
 *  set your Base SDK to v3.0 or higher.
 *
 */

- (YCNetworkStatus) localWiFiStatusForFlags: (SCNetworkReachabilityFlags) flags
{
	yclogReachabilityFlags(flags);
	
	BOOL retVal = NotReachable;
	if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
	{
		retVal = YCReachableViaWiFi;
	}
	return retVal;
}


- (YCNetworkStatus) networkStatusForFlagss: (SCNetworkReachabilityFlags) flags
{
	yclogReachabilityFlags(flags);
	if (!(flags & kSCNetworkReachabilityFlagsReachable))
	{
		// if target host is not reachable
		return NotReachable;
	}
	
	BOOL retVal = NotReachable;
	
	if (!(flags & kSCNetworkReachabilityFlagsConnectionRequired))
	{
		// if target host is reachable and no connection is required
		//  then we'll assume (for now) that your on Wi-Fi
		retVal = ReachableViaWiFi;
	}
	
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) // Apple advises you to use the magic number instead of a symbol.	
	if ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ||
		(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic))
#else
	if (flags & kSCNetworkReachabilityFlagsConnectionAutomatic)
#endif
		{
			// ... and the connection is on-demand (or on-traffic) if the
			//     calling application is using the CFSocketStream or higher APIs
			
			if (!(flags & kSCNetworkReachabilityFlagsInterventionRequired))
			{
				// ... and no [user] intervention is needed
				retVal = ReachableViaWiFi;
			}
		}
	
	if (flags & kSCNetworkReachabilityFlagsIsWWAN)
	{
		// ... but WWAN connections are OK if the calling application
		//     is using the CFNetwork (CFSocketStream?) APIs.
		retVal = ReachableViaWWAN;
	}
	return retVal;
}


- (YCNetworkStatus) yccurrentReachabilityStatus
{
	NSAssert(ycreachabilityRef, @"currentReachabilityStatus called with NULL reachabilityRef");
	
	NetworkStatus retVal = NotReachable;
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags))
	{
		if(self.key == kLocalWiFiConnection)
		{
			retVal = [self localWiFiStatusForFlags: flags];
		}
		else
		{
			retVal = [self networkStatusForFlagss: flags];
		}
	}
	return retVal;
}


- (BOOL) ycisReachable {
	
	NSAssert(ycreachabilityRef, @"isReachable called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags = 0;
	NetworkStatus status = kNotReachable;
	
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags)) {
		
		logReachabilityFlags(flags);
		
		if(self.key == kLocalWiFiConnection) {
			
			status = [self localWiFiStatusForFlags: flags];
			
		} else {
			
			status = [self networkStatusForFlagss: flags];
			
		}
		
		return (kNotReachable != status);
		
	}
	
	return NO;
	
} // isReachable


- (BOOL) ycisConnectionRequired {
	
	return [self connectionRequired];
	
} // isConnectionRequired


- (BOOL) ycconnectionRequired {
	
	NSAssert(ycreachabilityRef, @"connectionRequired called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(ycreachabilityRef, &flags)) {
		
		logReachabilityFlags(flags);
		
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
		
	}
	
	return NO;
	
} // connectionRequired
#endif
             
@end




