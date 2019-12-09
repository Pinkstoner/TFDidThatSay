
#import "Slide.h"
#import "assets/MMMarkdown.h"

static BOOL isSlideEnabled;
static BOOL isSlideDeletedOnly;
static CGFloat pushshiftRequestTimeoutValue;

%group Slide

@implementation FontGenerator

+(UIFont *) fontOfSize:(CGFloat) size submission:(BOOL) isSubmission willOffset:(BOOL) willOffset{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *fontName;
	CGFloat fontSize = size;
	
	if (willOffset){
		if (isSubmission){
			fontSize += ([userDefaults objectForKey:@"POST_FONT_SIZE"] == nil) ? 0 : [userDefaults integerForKey:@"POST_FONT_SIZE"];
		} else {
			fontSize += ([userDefaults objectForKey:@"COMMENT_FONT_SIZE"] == nil) ? -2 : [userDefaults integerForKey:@"COMMENT_FONT_SIZE"];
		}	
	}
	
	if ([userDefaults stringForKey:(isSubmission ? @"postfont" : @"commentfont")] == nil){
		fontName =  isSubmission ? @"AvenirNext-DemiBold" : @"AvenirNext-Medium";
	} else {
		fontName = [userDefaults stringForKey:(isSubmission ? @"postfont" : @"commentfont")];
	}
	
	UIFont *font = [UIFont fontWithName:fontName size:fontSize]; 
	
	if (!font){
		font = [UIFont systemFontOfSize:fontSize];
	}
	
	return font;
}
 
+(UIFont *) boldFontOfSize:(CGFloat) size submission:(BOOL) isSubmission willOffset:(BOOL) willOffset {
	UIFont *font = [self fontOfSize:size submission:isSubmission willOffset:willOffset];
	
	if ([font.fontName isEqualToString:[UIFont systemFontOfSize:10].fontName]){
		return [UIFont boldSystemFontOfSize:font.pointSize];
	} else {
		UIFontDescriptor *desc = [font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
		
		if (desc == nil){
			return font;
		} else {
			return [UIFont fontWithDescriptor:desc size: 0];
		}
	}
}

+(UIFont *) italicFontOfSize:(CGFloat) size submission:(BOOL) isSubmission willOffset:(BOOL) willOffset {
	UIFont *font = [self fontOfSize:size submission:isSubmission willOffset:willOffset];
	
	if ([font.fontName isEqualToString:[UIFont systemFontOfSize:10].fontName]){
		return [UIFont italicSystemFontOfSize:font.pointSize];
	} else {
		UIFontDescriptor *desc = [font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
		
		if (desc == nil){
			return font;
		} else {
			return [UIFont fontWithDescriptor:desc size: 0];
		}
	}
}

@end


@implementation ColorUtil 

+(UIColor *) accentColorForSub:(NSString *) subreddit{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSData *colorData = [userDefaults dataForKey:[NSString stringWithFormat:@"accent+%@", subreddit]];
	UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
	if (color) {
		return color;
	} else {
		UIColor *baseAccentColor = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults dataForKey:@"accentcolor"]];
		
		if (baseAccentColor){
			return baseAccentColor;
		} else {
			return [UIColor colorWithRed:0.161 green:0.475 blue:1.0 alpha:1.0];
		}
	}
}

+(UIColor *) fontColorForTheme:(NSString *)theme{
	UIColor *fontColor;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	//if only switch blocks worked with strings...
	if ([theme isEqualToString:@"light"]) {
		fontColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.87];
	} else if ([theme isEqualToString:@"dark"]) {
		fontColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.87];
	} else if ([theme isEqualToString:@"black"]) {
		fontColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.87];
	} else if ([theme isEqualToString:@"blue"]) {
		fontColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.87];
	} else if ([theme isEqualToString:@"sepia"]) {
		fontColor = [UIColor colorWithRed:0.243 green:.239 blue:.212 alpha:0.87]; 
	} else if ([theme isEqualToString:@"red"]) {
		fontColor = [UIColor colorWithRed:1.0 green:0.969 blue:0.929 alpha:0.87]; 
	} else if ([theme isEqualToString:@"deep"]) {
		fontColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.87];
	} else if ([theme isEqualToString:@"mint"]) {
		fontColor = [UIColor colorWithRed:0.035 green:0.212 blue:0.059 alpha:0.87];
	} else if ([theme isEqualToString:@"cream"]) {
		fontColor = [UIColor colorWithRed:0.267 green:0.255 blue:0.224 alpha:0.87];
	} else if ([theme isEqualToString:@"acontrast"]) {
		fontColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.87];
	} else if ([theme isEqualToString:@"pink"]) {
		fontColor = [UIColor colorWithRed:0.149 green:0.157 blue:0.267 alpha:0.87];
	} else if ([theme isEqualToString:@"solarize"]) {
		fontColor = [UIColor colorWithRed:0.514 green:0.580 blue:0.588 alpha:0.87];
	} else if (!theme) {
		fontColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.87];
	} else {
		NSString *customThemeString = [[userDefaults stringForKey:[NSString stringWithFormat:@"Theme+%@", theme]] stringByRemovingPercentEncoding];
		if (customThemeString) {
			NSString *customFontColorHex = [customThemeString componentsSeparatedByString:@"#"][4];
			fontColor =  [UIColor colorWithHex:customFontColorHex]; 
		} else {
			fontColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.87];
		}
	}
	
	return fontColor;
}

+(UIColor *) backgroundColorForTheme:(NSString *) theme{
	UIColor *backgroundColor;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	if ([theme isEqualToString:@"light"]) {
		backgroundColor = [UIColor colorWithRed:0.352 green:0.352 blue:0.352 alpha:1.0];
	} else if ([theme isEqualToString:@"dark"]) {
		backgroundColor = [UIColor colorWithRed:0.051 green:0.051 blue:0.051 alpha:1.0];
	} else if ([theme isEqualToString:@"black"]) {
		backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
	} else if ([theme isEqualToString:@"blue"]) {
		backgroundColor = [UIColor colorWithRed:0.071 green:0.094 blue:0.106 alpha:1.0];
	} else if ([theme isEqualToString:@"sepia"]) {
		backgroundColor = [UIColor colorWithRed:0.310 green:0.302 blue:0.267 alpha:1.0]; 
	} else if ([theme isEqualToString:@"red"]) {
		backgroundColor = [UIColor colorWithRed:0.075 green:0.055 blue:0.051 alpha:1.0]; 
	} else if ([theme isEqualToString:@"deep"]) {
		backgroundColor = [UIColor colorWithRed:0.035 green:0.035 blue:0.043 alpha:1.0];
	} else if ([theme isEqualToString:@"mint"]) {
		backgroundColor = [UIColor colorWithRed:0.364 green:0.376 blue:0.357 alpha:1.0];
	} else if ([theme isEqualToString:@"cream"]) {
		backgroundColor = [UIColor colorWithRed:0.322 green:0.314 blue:0.286 alpha:1.0];
	} else if ([theme isEqualToString:@"acontrast"]) {
		backgroundColor = [UIColor colorWithRed:0.027 green:0.027 blue:0.24 alpha:1.0];
	} else if ([theme isEqualToString:@"pink"]) {
		backgroundColor = [UIColor colorWithRed:1.0 green:0.376 blue:0.357 alpha:1.0];
	} else if ([theme isEqualToString:@"solarize"]) {
		backgroundColor = [UIColor colorWithRed:0.040 green:0.067 blue:0.082 alpha:1.0];
	} else if (!theme) {
		backgroundColor = [UIColor colorWithRed:0.352 green:0.352 blue:0.352 alpha:1.0];
	} else {
		NSString *customThemeString = [[userDefaults stringForKey:[NSString stringWithFormat:@"Theme+%@", theme]] stringByRemovingPercentEncoding];
		if (customThemeString) {
			NSString *customFontColorHex = [customThemeString componentsSeparatedByString:@"#"][3];
			backgroundColor =  [UIColor colorWithHex:customFontColorHex]; 
		} else {
			backgroundColor = [UIColor colorWithRed:0.352 green:0.352 blue:0.352 alpha:1.0];
		}
	} 
	
	return backgroundColor;
}

@end


static UIButton * createUndeleteButton(){
	
	UIButton *undeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];		
	UIImage *undeleteImage = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/Application Support/TFDidThatSay/eye160white.png"];
	
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 0);
	[undeleteImage drawInRect:CGRectMake(0, 0, 20, 20)];
	undeleteImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(35, 35), NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	[undeleteImage drawAtPoint:CGPointMake(7.5, 7.5)];
	UIGraphicsPopContext();
	undeleteImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[undeleteButton setImage:undeleteImage forState:UIControlStateNormal];
	undeleteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	return undeleteButton;
}


//because it wont compile without this
%hook RComment
%end


%hook UIColor

%new
+(UIColor *) colorWithHex:(NSString *) arg1 {
	if (!arg1){
		NSString *firstChar = [arg1 substringToIndex:1];
		if ([firstChar isEqualToString:@"#"]){
			arg1 = [arg1 substringWithRange:NSMakeRange(1, [arg1 length]-1)];
		}
		
		unsigned rgbValue = 0;
		NSScanner *scanner = [NSScanner scannerWithString:arg1];
		[scanner scanHexInt:&rgbValue];
			
		return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:0.87];
	} else {
		return nil;
	}
}

%new 
-(NSString *) hexString {
	const CGFloat *components = CGColorGetComponents(self.CGColor);

    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];

    return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
}

%end


%hook CommentDepthCell

-(void) doShortClick{
	%orig;
	
	[self addUndeleteButtonToMenu];
}

-(void) doLongClick	{
	%orig;
	
	[self addUndeleteButtonToMenu];
}

%new 
-(void) addUndeleteButtonToMenu{
	
	NSString *body = [MSHookIvar<id>(self, "comment") body];
	
	if ((isSlideDeletedOnly && ([body isEqualToString:@"[deleted]"] || [body isEqualToString:@"[removed]"])) || !isSlideDeletedOnly){
	
		id controller = MSHookIvar<id>(self, "parent");
		
		if (MSHookIvar<id>(controller, "menuCell")){
			
			UIStackView *menu = MSHookIvar<UIStackView *>(self, "menu");
			
			if (![[[[menu arrangedSubviews] lastObject] actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] containsObject:@"handleUndeleteComment:"]){
				UIButton *undeleteButton = createUndeleteButton();
				[undeleteButton addTarget:self action:@selector(handleUndeleteComment:) forControlEvents:UIControlEventTouchUpInside];
			
				[menu addArrangedSubview:undeleteButton];
			}
		}
	}
}

%new
-(void) handleUndeleteComment:(id) sender{
	
	[sender setEnabled:NO];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	id textStackDisplayView = MSHookIvar<id>(self, "commentBody");
	id comment = MSHookIvar<id>(self, "comment");
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];

	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.pushshift.io/reddit/search/comment/?ids=%@&fields=author,body",[[comment id] componentsSeparatedByString:@"_"][1]]]];
	[request setHTTPMethod:@"GET"];
	[request setTimeoutInterval:pushshiftRequestTimeoutValue];

	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
	
		NSString *author = @"[author]";
		NSString *body = @"[body]";

		if (data != nil && error == nil){
			id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
			if ([[jsonData objectForKey:@"data"] count] != 0){
				author = [[jsonData objectForKey:@"data"][0] objectForKey:@"author"];
				body = [[jsonData objectForKey:@"data"][0] objectForKey:@"body"];
				if ([body isEqualToString:@"[deleted]"] || [body isEqualToString:@"[removed]"]){
					body = @"[pushshift was unable to archive this]";
				}
			} else {
				body = @"[pushshift has not archived this yet]";
			}
		} else if (error != nil || data == nil){
			body = [NSString stringWithFormat:@"[an error occured while attempting to contact pushshift api (%@)]", [error localizedDescription]];
		}
		
		//Attributed string generation rewrote from Slide_for_Reddit.TextDisplayStackView.createAttributedChunk(...) 
		
		UIFont *font = [%c(FontGenerator) fontOfSize:MSHookIvar<CGFloat>(textStackDisplayView, "fontSize") submission:NO willOffset:YES];
			
		NSString *themeName = [userDefaults stringForKey:@"theme"];
		UIColor *fontColor = [%c(ColorUtil) fontColorForTheme:themeName];
		UIColor *accentColor = [%c(ColorUtil) accentColorForSub:[comment subreddit]];
		
		NSString *html = [%c(MMMarkdown) HTMLStringWithMarkdown:body extensions:MMMarkdownExtensionsGitHubFlavored error:nil];
		html = [[html stringByReplacingOccurrencesOfString:@"<sup>" withString:@"<font size=\"1\">"] stringByReplacingOccurrencesOfString:@"</sup>" withString:@"</font>"];
		html = [[html stringByReplacingOccurrencesOfString:@"<del>" withString:@"<font color=\"green\">"] stringByReplacingOccurrencesOfString:@"</del>" withString:@"</font>"];
		html = [[html stringByReplacingOccurrencesOfString:@"<code>" withString:@"<font color=\"blue\">"] stringByReplacingOccurrencesOfString:@"</code>" withString:@"</font>"];
		html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		DTHTMLAttributedStringBuilder *dthtmlBuilder = [[%c(DTHTMLAttributedStringBuilder) alloc] initWithHTML:[html dataUsingEncoding:NSUTF8StringEncoding] options:@{@"DTUseiOS6Attributes": @YES, @"DTDefaultTextColor": fontColor, @"DTDefaultFontSize": @([font pointSize])} documentAttributes:nil];
		
		NSMutableAttributedString *htmlAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[dthtmlBuilder generatedAttributedString]];
		NSRange htmlStringRange = NSMakeRange(0, [htmlAttributedString length]);
		
		[[htmlAttributedString mutableString] replaceOccurrencesOfString:@"\t•\t" withString:@" • " options:nil range: htmlStringRange];
		[[htmlAttributedString mutableString] replaceOccurrencesOfString:@"\t◦\t" withString:@"  ◦ " options:nil range: htmlStringRange];
		[[htmlAttributedString mutableString] replaceOccurrencesOfString:@"\t▪\t" withString:@"   ▪ " options:nil range: htmlStringRange];
		
		[htmlAttributedString removeAttribute:@"CTForegroundColorFromContext" range:htmlStringRange];
		
		[htmlAttributedString enumerateAttributesInRange:htmlStringRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
			for (NSString *key in attributes){
				
				if ([(UIColor *) attributes[key] isKindOfClass:[UIColor class]]){
					UIColor *attrColor = (UIColor *) attributes[key];
					if ([[attrColor hexString] isEqualToString:@"#0000FF"]){
						UIFont *tempFont = [UIFont fontWithName:@"Courier" size:font.pointSize];
						
						[htmlAttributedString setAttributes:@{NSForegroundColorAttributeName: accentColor, NSBackgroundColorAttributeName: [%c(ColorUtil) backgroundColorForTheme:themeName], NSFontAttributeName: (tempFont ? tempFont : font)} range:range];
					} else if ([[attrColor hexString] isEqualToString:@"#008000"]) {
						[htmlAttributedString setAttributes:@{NSForegroundColorAttributeName: fontColor, NSFontAttributeName:font} range:range];
					}
				} else if ([(NSURL *) attributes[key] isKindOfClass:[NSURL class]]){
					NSURL *attrUrl = (NSURL *)attributes[key];

					if (([userDefaults objectForKey:@"ENLARGE_LINKS"] == nil) ? YES : [userDefaults boolForKey:@"ENLARGE_LINKS"]){
						[htmlAttributedString addAttribute:NSFontAttributeName value:[%c(FontGenerator) boldFontOfSize:18 submission:NO willOffset:YES] range:range];
					}
					
					[htmlAttributedString addAttribute:NSForegroundColorAttributeName value:accentColor range:range]; 
					[htmlAttributedString addAttribute:NSUnderlineColorAttributeName value:[UIColor clearColor] range:range];
		
					//skipping showLinkContentType b/c not necessary and spoilers b/c MMMarkdown doesn't support them

					[htmlAttributedString yy_setTextHighlightRange:range color: accentColor backgroundColor:nil userInfo:@{@"url": attrUrl}];
					break; 
				} 
			}
		}];
		
		[htmlAttributedString beginEditing];
		[htmlAttributedString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, [htmlAttributedString length]) options:nil usingBlock:^(id value, NSRange range, BOOL *stop){
			
			UIFont *attrFont = (UIFont *)value;
			
			BOOL isBold = (attrFont.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) != 0;
			BOOL isItalic = (attrFont.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) != 0;
			
			UIFont *newFont = font;
			
			if (isBold){
				newFont = [%c(FontGenerator) boldFontOfSize:attrFont.pointSize submission:NO willOffset:NO];
			} else if (isItalic){
				newFont = [%c(FontGenerator) italicFontOfSize:attrFont.pointSize submission:NO willOffset:NO];
			}
		
			[htmlAttributedString removeAttribute:NSFontAttributeName range:range];
			[htmlAttributedString addAttribute:NSFontAttributeName value:newFont range:range];	
		
		}];
		[htmlAttributedString endEditing];
		
		NSMutableAttributedString *newCommentText = [MSHookIvar<NSMutableAttributedString *>(self, "cellContent") initWithAttributedString:htmlAttributedString];
		NSAttributedString *tempAttributedString = [[NSAttributedString alloc] initWithString:@""];
		[newCommentText appendAttributedString:tempAttributedString]; //to keep the compiler happy
		
		[comment setAuthor:author];
		[comment setBody:body];	
		
		id controller = MSHookIvar<id>(self, "parent");
		
		[self performSelectorOnMainThread:@selector(showMenu:) withObject:nil waitUntilDone:YES];
		[MSHookIvar<id>(controller, "tableView") performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
		
		[sender setEnabled:YES];
	}];
}

%end

%end


static void loadPrefs(){
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lint.undelete.prefs.plist"];
	
	if (prefs){
		
		if ([prefs objectForKey:@"isSlideEnabled"] != nil){
			isSlideEnabled = [[prefs objectForKey:@"isSlideEnabled"] boolValue];
		} else {
			isSlideEnabled = YES;
		}
		
		if ([prefs objectForKey:@"isSlideDeletedOnly"] != nil){
			isSlideDeletedOnly = [[prefs objectForKey:@"isSlideDeletedOnly"] boolValue];
		} else {
			isSlideDeletedOnly = YES;
		}
		
		if ([prefs objectForKey:@"requestTimeoutValue"] != nil){
			pushshiftRequestTimeoutValue = [[prefs objectForKey:@"requestTimeoutValue"] doubleValue];
		} else {
			pushshiftRequestTimeoutValue = 10;
		}
		
	} else {
		isSlideEnabled = YES;
		isSlideDeletedOnly = YES;
		pushshiftRequestTimeoutValue = 10;
	}	
}

static void prefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  loadPrefs();
}


%ctor {
	loadPrefs();
	
	NSString* processName = [[NSProcessInfo processInfo] processName];

	if ([processName isEqualToString:@"Slide for Reddit"]){
		if (isSlideEnabled){
			
			CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, prefsChanged, CFSTR("com.lint.undelete.prefs.changed"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
			
			%init(Slide, CommentDepthCell = objc_getClass("Slide_for_Reddit.CommentDepthCell"), RComment = objc_getClass("Slide_for_Reddit.RSubmission"));
		}
	}
}
