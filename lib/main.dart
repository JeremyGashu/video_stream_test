import 'package:encryption_test/musics_page.dart';
import 'package:encryption_test/videos.dart';
import 'package:flutter/material.dart';

String mu38String = """
#EXTM3U
#EXT-X-TARGETDURATION:10
#EXT-X-ALLOW-CACHE:YES
#EXT-X-PLAYLIST-TYPE:VOD
#EXT-X-VERSION:3
#EXT-X-MEDIA-SEQUENCE:1
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment1_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment2_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment3_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment4_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment5_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment6_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment7_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment8_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment9_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment10_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment11_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment12_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment13_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment14_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment15_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment16_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment17_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment18_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment19_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment20_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment21_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment22_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment23_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment24_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment25_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment26_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment27_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment28_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment29_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment30_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment31_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment32_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment33_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment34_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment35_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment36_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment37_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment38_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment39_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment40_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment41_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment42_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment43_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment44_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment45_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment46_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment47_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment48_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment49_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment50_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment51_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment52_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment53_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment54_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment55_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment56_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment57_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment58_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment59_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment60_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment61_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment62_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment63_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment64_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment65_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment66_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment67_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment68_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment69_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment70_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment71_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment72_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment73_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment74_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment75_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment76_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment77_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment78_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment79_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment80_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment81_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment82_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment83_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment84_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment85_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment86_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment87_0_av.ts
#EXTINF:10.000,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment88_0_av.ts
#EXTINF:8.042,
https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/segment89_0_av.ts
#EXT-X-ENDLIST
""";

void main() async {
  // var playlist = await parseHLS();

  //todo print(playlist.segments);
  //todo generate ListView based on this segments and make it some kind of dynamic content
  //todo don't display all the segments display 20 of them for now

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.red,
    ),
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> _widgets = [
    Videos(),
    MusicPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgets[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.ondemand_video_sharp,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.music_note,
              ))
        ],
        currentIndex: _currentIndex,
      ),
    );
  }
}

class HlsParsing extends StatefulWidget {
  @override
  _HlsParsingState createState() => _HlsParsingState();
}

class _HlsParsingState extends State<HlsParsing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'HLS Parsing',
        ),
      ),
    );
  }
}
//
// parseHLS() async {
//   Uri playlistUri;
//   var playList;
//   try {
//     playList = await HlsPlaylistParser.create().parseString(playlistUri, a);
//   } on ParserException catch (e) {
//     print(e);
//   }
//   return playList;
// }

// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:just_audio/just_audio.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   AudioPlayer _player;
//   ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: [
//     LoopingAudioSource(
//       count: 2,
//       child: ClippingAudioSource(
//         start: Duration(seconds: 60),
//         end: Duration(seconds: 65),
//         child: AudioSource.uri(Uri.parse(
//             "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
//         tag: AudioMetadata(
//           album: "Science Friday",
//           title: "A Salute To Head-Scratching Science (5 seconds)",
//           artwork:
//               "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//         ),
//       ),
//     ),
//     AudioSource.uri(
//       Uri.parse(
//           "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
//       tag: AudioMetadata(
//         album: "Science Friday",
//         title: "A Salute To Head-Scratching Science",
//         artwork:
//             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//       ),
//     ),
//     AudioSource.uri(
//       Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
//       tag: AudioMetadata(
//         album: "Science Friday",
//         title: "From Cat Rheology To Operatic Incompetence",
//         artwork:
//             "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//       ),
//     ),
//   ]);
//
//   @override
//   void initState() {
//     super.initState();
//     AudioPlayer.setIosCategory(IosCategory.playback);
//     _player = AudioPlayer();
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.black,
//     ));
//     _loadAudio();
//   }
//
//   _loadAudio() async {
//     try {
//       await _player.load(_playlist);
//     } catch (e) {
//       // catch load errors: 404, invalid url ...
//       print("An error occured $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: StreamBuilder<SequenceState>(
//                   stream: _player.sequenceStateStream,
//                   builder: (context, snapshot) {
//                     final state = snapshot.data;
//                     if (state?.sequence?.isEmpty ?? true) return SizedBox();
//                     final metadata = state.currentSource.tag as AudioMetadata;
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child:
//                                 Center(child: Image.network(metadata.artwork)),
//                           ),
//                         ),
//                         Text(metadata.album ?? '',
//                             style: Theme.of(context).textTheme.headline6),
//                         Text(metadata.title ?? ''),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               ControlButtons(_player),
//               StreamBuilder<Duration>(
//                 stream: _player.durationStream,
//                 builder: (context, snapshot) {
//                   final duration = snapshot.data ?? Duration.zero;
//                   return StreamBuilder<Duration>(
//                     stream: _player.positionStream,
//                     builder: (context, snapshot) {
//                       var position = snapshot.data ?? Duration.zero;
//                       if (position > duration) {
//                         position = duration;
//                       }
//                       return SeekBar(
//                         duration: duration,
//                         position: position,
//                         onChangeEnd: (newPosition) {
//                           _player.seek(newPosition);
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//               SizedBox(height: 8.0),
//               Row(
//                 children: [
//                   StreamBuilder<LoopMode>(
//                     stream: _player.loopModeStream,
//                     builder: (context, snapshot) {
//                       final loopMode = snapshot.data ?? LoopMode.off;
//                       const icons = [
//                         Icon(Icons.repeat, color: Colors.grey),
//                         Icon(Icons.repeat, color: Colors.orange),
//                         Icon(Icons.repeat_one, color: Colors.orange),
//                       ];
//                       const cycleModes = [
//                         LoopMode.off,
//                         LoopMode.all,
//                         LoopMode.one,
//                       ];
//                       final index = cycleModes.indexOf(loopMode);
//                       return IconButton(
//                         icon: icons[index],
//                         onPressed: () {
//                           _player.setLoopMode(cycleModes[
//                               (cycleModes.indexOf(loopMode) + 1) %
//                                   cycleModes.length]);
//                         },
//                       );
//                     },
//                   ),
//                   Expanded(
//                     child: Text(
//                       "Playlist",
//                       style: Theme.of(context).textTheme.headline6,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   StreamBuilder<bool>(
//                     stream: _player.shuffleModeEnabledStream,
//                     builder: (context, snapshot) {
//                       final shuffleModeEnabled = snapshot.data ?? false;
//                       return IconButton(
//                         icon: shuffleModeEnabled
//                             ? Icon(Icons.shuffle, color: Colors.orange)
//                             : Icon(Icons.shuffle, color: Colors.grey),
//                         onPressed: () {
//                           _player.setShuffleModeEnabled(!shuffleModeEnabled);
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               Container(
//                 height: 240.0,
//                 child: StreamBuilder<SequenceState>(
//                   stream: _player.sequenceStateStream,
//                   builder: (context, snapshot) {
//                     final state = snapshot.data;
//                     final sequence = state?.sequence ?? [];
//                     return ListView.builder(
//                       itemCount: sequence.length,
//                       itemBuilder: (context, index) => Material(
//                         color: index == state.currentIndex
//                             ? Colors.grey.shade300
//                             : null,
//                         child: ListTile(
//                           title: Text(sequence[index].tag.title),
//                           onTap: () {
//                             _player.seek(Duration.zero, index: index);
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;
//
//   ControlButtons(this.player);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: Icon(Icons.volume_up),
//           onPressed: () {
//             _showSliderDialog(
//               context: context,
//               title: "Adjust volume",
//               divisions: 10,
//               min: 0.0,
//               max: 1.0,
//               stream: player.volumeStream,
//               onChanged: player.setVolume,
//             );
//           },
//         ),
//         StreamBuilder<SequenceState>(
//           stream: player.sequenceStateStream,
//           builder: (context, snapshot) => IconButton(
//             icon: Icon(Icons.skip_previous),
//             onPressed: player.hasPrevious ? player.seekToPrevious : null,
//           ),
//         ),
//         StreamBuilder<PlayerState>(
//           stream: player.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;
//             if (processingState == ProcessingState.loading ||
//                 processingState == ProcessingState.buffering) {
//               return Container(
//                 margin: EdgeInsets.all(8.0),
//                 width: 64.0,
//                 height: 64.0,
//                 child: CircularProgressIndicator(),
//               );
//             } else if (playing != true) {
//               return IconButton(
//                 icon: Icon(Icons.play_arrow),
//                 iconSize: 64.0,
//                 onPressed: player.play,
//               );
//             } else if (processingState != ProcessingState.completed) {
//               return IconButton(
//                 icon: Icon(Icons.pause),
//                 iconSize: 64.0,
//                 onPressed: player.pause,
//               );
//             } else {
//               return IconButton(
//                 icon: Icon(Icons.replay),
//                 iconSize: 64.0,
//                 onPressed: () => player.seek(Duration.zero, index: 0),
//               );
//             }
//           },
//         ),
//         StreamBuilder<SequenceState>(
//           stream: player.sequenceStateStream,
//           builder: (context, snapshot) => IconButton(
//             icon: Icon(Icons.skip_next),
//             onPressed: player.hasNext ? player.seekToNext : null,
//           ),
//         ),
//         StreamBuilder<double>(
//           stream: player.speedStream,
//           builder: (context, snapshot) => IconButton(
//             icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             onPressed: () {
//               _showSliderDialog(
//                 context: context,
//                 title: "Adjust speed",
//                 divisions: 10,
//                 min: 0.5,
//                 max: 1.5,
//                 stream: player.speedStream,
//                 onChanged: player.setSpeed,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class SeekBar extends StatefulWidget {
//   final Duration duration;
//   final Duration position;
//   final ValueChanged<Duration> onChanged;
//   final ValueChanged<Duration> onChangeEnd;
//
//   SeekBar({
//     @required this.duration,
//     @required this.position,
//     this.onChanged,
//     this.onChangeEnd,
//   });
//
//   @override
//   _SeekBarState createState() => _SeekBarState();
// }
//
// class _SeekBarState extends State<SeekBar> {
//   double _dragValue;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Slider(
//           min: 0.0,
//           max: widget.duration.inMilliseconds.toDouble(),
//           value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
//               widget.duration.inMilliseconds.toDouble()),
//           onChanged: (value) {
//             setState(() {
//               _dragValue = value;
//             });
//             if (widget.onChanged != null) {
//               widget.onChanged(Duration(milliseconds: value.round()));
//             }
//           },
//           onChangeEnd: (value) {
//             if (widget.onChangeEnd != null) {
//               widget.onChangeEnd(Duration(milliseconds: value.round()));
//             }
//             _dragValue = null;
//           },
//         ),
//         Positioned(
//           right: 16.0,
//           bottom: 0.0,
//           child: Text(
//               RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
//                       .firstMatch("$_remaining")
//                       ?.group(1) ??
//                   '$_remaining',
//               style: Theme.of(context).textTheme.caption),
//         ),
//       ],
//     );
//   }
//
//   Duration get _remaining => widget.duration - widget.position;
// }
//
// _showSliderDialog({
//   BuildContext context,
//   String title,
//   int divisions,
//   double min,
//   double max,
//   String valueSuffix = '',
//   Stream<double> stream,
//   ValueChanged<double> onChanged,
// }) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text(title, textAlign: TextAlign.center),
//       content: StreamBuilder<double>(
//         stream: stream,
//         builder: (context, snapshot) => Container(
//           height: 100.0,
//           child: Column(
//             children: [
//               Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
//                   style: TextStyle(
//                       fontFamily: 'Fixed',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24.0)),
//               Slider(
//                 divisions: divisions,
//                 min: min,
//                 max: max,
//                 value: snapshot.data ?? 1.0,
//                 onChanged: onChanged,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// class AudioMetadata {
//   final String album;
//   final String title;
//   final String artwork;
//
//   AudioMetadata({this.album, this.title, this.artwork});
// }
