//
//  ALAssetRepresentation+MD5.m
//  ALAssetRepresentation+MD5
//
//  Created by Matt Donnelly on 12/02/2013.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ALAssetRepresentation+MD5.h"
#import <CommonCrypto/CommonDigest.h>

static const int BUFFER_SIZE = 4096;

@implementation ALAssetRepresentation (MD5)

- (NSString *)MD5 
{	
	CFStringRef result = NULL;
	
	CC_MD5_CTX hashObject;
	CC_MD5_Init(&hashObject);
		
	uint8_t *buffer = (uint8_t*)malloc(BUFFER_SIZE);
	
	int read = 0;
	int offset = 0;
	
	NSError *err;
	
	if ([self size] != 0) {
		do {
			read = [self getBytes:buffer fromOffset:offset length:BUFFER_SIZE error:&err];
			offset += read;
			
			CC_MD5_Update(&hashObject, (const void *)buffer, (CC_LONG)read);
		} while (read != 0);
	}
	
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final(digest, &hashObject);
	     
	char hash[2 * sizeof(digest) + 1];
	for (size_t i = 0; i < sizeof(digest); ++i) {
		snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
	}
	
	result = CFStringCreateWithCString(kCFAllocatorDefault, (const char *)hash, kCFStringEncodingUTF8);
	
	return (NSString *)result;
}

@end