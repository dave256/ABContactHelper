/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "ABContactsHelper.h"

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]

@interface TestBedViewController : UIViewController
{
	NSMutableString *log;
	IBOutlet UITextView *textView;
}
@property (retain) NSMutableString *log;
@property (retain) UITextView *textView;
@end

@implementation TestBedViewController
@synthesize log;
@synthesize textView;

- (void) doLog: (NSString *) formatstring, ...
{
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	NSString *outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
	[self.log appendString:outstring];
	[self.log appendString:@"\n"];
	self.textView.text = self.log;
}

- (void) addGW
{
	// Search for a contact, creating a new one if one is not found
	NSArray *contacts = [ABContactsHelper contactsMatchingName:@"Washington" andName:@"George"];
	printf("%d matching contacts found\n", contacts.count);
	ABContact *peep = contacts.count ? [contacts lastObject] : [ABContact contact];
	
	if (contacts.count) [peep removeSelfFromAddressBook]; // remove in preparation to update contact
	printf("Record %d\n", peep.recordID);
	
	// Person basic string information (see full list in ABContact)
	peep.firstname = @"George";
	peep.lastname = @"Washington";
	peep.nickname = @"Prez";
	peep.firstnamephonetic = @"Horhay";
	peep.lastnamephonetic = @"Warsh-ing-town";
	peep.jobtitle = @"President of the United States of America";
	
	// Emails
	NSMutableArray *emailarray = [NSMutableArray array];
	[emailarray addObject:[ABContact dictionaryWithValue:@"george@home.com" andLabel:kABHomeLabel]];
	[emailarray addObject:[ABContact dictionaryWithValue:@"george@work.com" andLabel:kABWorkLabel]];
	[emailarray addObject:[ABContact dictionaryWithValue:@"george@gmail.com" andLabel:(CFStringRef) @"Google"]];
	peep.emailDictionaries = emailarray;
	
	// Phones
	NSMutableArray *phonearray = [NSMutableArray array];
	[phonearray addObject:[ABContact dictionaryWithValue:@"202-555-1212" andLabel:kABPersonPhoneMainLabel]];
	[phonearray addObject:[ABContact dictionaryWithValue:@"202-555-1313" andLabel:(CFStringRef) @"Google"]];
	[phonearray addObject:[ABContact dictionaryWithValue:@"202-555-1414" andLabel:kABPersonPhoneMobileLabel]];
	peep.phoneDictionaries = phonearray;
	
	// URLS
	NSMutableArray *urls = [NSMutableArray array];
	[urls addObject:[ABContact dictionaryWithValue:@"http://whitehouse.org" andLabel:kABPersonHomePageLabel]];
	[urls addObject:[ABContact dictionaryWithValue:@"http://en.wikipedia.org/wiki/Washington" andLabel:kABOtherLabel]];
	peep.urlDictionaries = urls;
	
	// Dates
	NSMutableArray *dates = [NSMutableArray array];
	[dates addObject:[ABContact dictionaryWithValue:[NSDate dateWithTimeIntervalSinceNow:0] andLabel:(CFStringRef) @"Anniversary"]];
	peep.dateDictionaries = dates;
	
	// Addresses
	NSDictionary *addy = [ABContact addressWithStreet:@"1600 Pennsylvania Avenue" withCity:@"Arlington" withState:@"Virginia" withZip:@"20202" withCountry:nil withCode:nil];
	NSMutableArray *addies = [NSMutableArray array];
	[addies addObject:[ABContact dictionaryWithValue:addy andLabel:kABHomeLabel]];
	peep.addressDictionaries = addies;

	// SMSes
	NSDictionary *sms = [ABContact smsWithService:kABPersonInstantMessageServiceAIM andUser:@"geow1735"];
	NSMutableArray *smses = [NSMutableArray array];
	[smses addObject:[ABContact dictionaryWithValue:sms andLabel:kABWorkLabel]];
	peep.smsDictionaries = smses;
	
	// Relationships (Not actually used on the iPhone, but here for the sake of example)
	 NSMutableArray *relatedarray = [NSMutableArray array];
	 [relatedarray addObject:[ABContact dictionaryWithValue:@"Ethel Washington" andLabel:kABPersonMotherLabel]];
	 peep.relatedNameDictionaries = relatedarray;
	
	[ABContactsHelper addContact:peep]; // save to address book
}

- (void) scan
{
	for (ABContact *person in [ABContactsHelper people])
	{
		printf("******\n");
		printf("Name: %s\n", person.compositeName.UTF8String);
		printf("Organization: %s\n", person.organization.UTF8String);
		printf("Title: %s\n", person.jobtitle.UTF8String);
		printf("Department: %s\n", person.department.UTF8String);
		printf("Note: %s\n", person.note.UTF8String);
		printf("Creation Date: %s\n", [person.creationDate description].UTF8String);
		printf("Modification Date: %s\n", [person.modificationDate description].UTF8String);
		printf("Emails: %s\n", [person.emailDictionaries description].UTF8String);
		printf("Phones: %s\n", [person.phoneDictionaries description].UTF8String);
		printf("URLs: %s\n", [person.urlDictionaries description].UTF8String);
		printf("Addresses: %s\n\n", [person.addressDictionaries description].UTF8String);
	}
}	

- (void) viewDidLoad
{
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Add GW", @selector(addGW));
	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Scan", @selector(scan));
}
@end

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@end

@implementation TestBedAppDelegate
- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[TestBedViewController alloc] init]];
	[window addSubview:nav.view];
	[window makeKeyAndVisible];
}
@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
	[pool release];
	return retVal;
}