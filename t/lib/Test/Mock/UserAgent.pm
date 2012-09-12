package Test::Mock::UserAgent;

use 5.12.0;
use warnings;

use HTTP::Response;
use URI::QueryParam;

use Method::Signatures;
use Moose;
use namespace::autoclean;

has [qw( searches_remaining )] => (
    is => 'ro',
    isa => 'Int',
    writer => '_set_searches_remaining',
    default => 100,
);

my $assault_data = <<'END_AAA';
NZBID:1315691;
NZBNAME:Assault on Precinct 13 1976 DUAL COMPLETE BLURAY FULLSiZE;
LINK:nzbmatrix.com/nzb-details.php?id=1315691&hit=1;
SIZE:36287901859.8;
INDEX_DATE:2012-06-25 07:00:36;
USENET_DATE:2012-06-24 5:19:10;
CATEGORY:Movies > HD (Image);
GROUP:alt.binaries.illuminaten;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt0074156/;
LANGUAGE:English;
IMAGE:http://img685.imageshack.us/img685/1082/mv5bmtq5mjq3nzy2of5bml5.jpg;
REGION:0;
|
NZBID:1225223;
NZBNAME:Assault On Precinct 13 1976 1080p BluRay x264 CiNEFiLE;
LINK:nzbmatrix.com/nzb-details.php?id=1225223&hit=1;
SIZE:9850396344.32;
INDEX_DATE:2012-03-28 07:45:50;
USENET_DATE:2012-03-28 8:22:18;
CATEGORY:Movies > HD (x264);
GROUP:alt.binaries.hdtv.x264;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt0074156/;
LANGUAGE:English;
IMAGE:http://cdn3a.dvdempire.org/products/60/1436760h.jpg;
REGION:0;
|
NZBID:1181323;
NZBNAME:Assault On Precinct 13   1976 MULTi 1080p BluRay x264 ROUGH;
LINK:nzbmatrix.com/nzb-details.php?id=1181323&hit=1;
SIZE:8098309734.4;
INDEX_DATE:2012-02-12 22:27:19;
USENET_DATE:2012-02-12 5:56:26;
CATEGORY:Movies > HD (x264);
GROUP:alt.binaries.hdtv.x264;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt0074156/;
LANGUAGE:English;
IMAGE:http://img685.imageshack.us/img685/1082/mv5bmtq5mjq3nzy2of5bml5.jpg;
REGION:0;
|
NZBID:1180151;
NZBNAME:Assault On Precinct 13 1976 FRENCH 720p BluRay x264 ROUGH;
LINK:nzbmatrix.com/nzb-details.php?id=1180151&hit=1;
SIZE:4071809351.68;
INDEX_DATE:2012-02-11 20:32:54;
USENET_DATE:2012-02-11 6:52:34;
CATEGORY:Movies > HD (x264);
GROUP:alt.binaries.hdtv.x264;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt0074156/;
LANGUAGE:French;
IMAGE:http://img593.imageshack.us/img593/1082/mv5bmtq5mjq3nzy2of5bml5.jpg;
REGION:0;
|
NZBID:1073783;
NZBNAME:Assault On Precinct 13 1976 DVDR RESTORED CE NTSC DVD9;
LINK:nzbmatrix.com/nzb-details.php?id=1073783&hit=1;
SIZE:8430047723.52;
INDEX_DATE:2011-10-19 20:29:36;
USENET_DATE:2011-10-19 5:44:19;
CATEGORY:Movies > DVD;
GROUP:alt.binaries.dvd.classics;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt0074156/;
LANGUAGE:English;
IMAGE:http://img718.imageshack.us/img718/9724/assaultonprecinct131976l.jpg;
REGION:2;
|
NZBID:716787;
NZBNAME:Assault On Precinct 13 1976 480p BDRip XviD SHiRK;
LINK:nzbmatrix.com/nzb-details.php?id=716787&hit=1;
SIZE:1615499100.16;
INDEX_DATE:2010-08-21 10:09:55;
USENET_DATE:2010-08-19 5:05:38;
CATEGORY:Movies > BRRip;
GROUP:alt.binaries.boneless;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt0074156/;
LANGUAGE:English;
IMAGE:;
REGION:0;
|
NZBID:372984;
NZBNAME:Assault On Precinct 13 1976 720p BluRay x264 CiNEFiLE;
LINK:nzbmatrix.com/nzb-details.php?id=372984&hit=1;
SIZE:5110990110.72;
INDEX_DATE:2008-12-20 15:15:52;
USENET_DATE:2008-12-19 11:53:48;
CATEGORY:Movies > HD (x264);
GROUP:alt.binaries.hdtv.x264;
COMMENTS:0;
HITS:381;
NFO:no;
WEBLINK:http://www.imdb.com/title/tt0074156/;
LANGUAGE:English;
IMAGE:http://img88.imageshack.us/img88/8757/464971hql2.jpg;
REGION:0;
|
END_AAA

my $darkknight_data = <<'END_BBB';
NZBID:1376629;
NZBNAME:The Dark Knight Rises 2012 TS CAM XVID JOALBA;
LINK:nzbmatrix.com/nzb-details.php?id=1376629&hit=1;
SIZE:2506641899.52;
INDEX_DATE:2012-09-07 05:41:00;
USENET_DATE:2012-09-06 5:14:19;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies;
COMMENTS:0;
HITS:0;
NFO:;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:;
REGION:0;
|
NZBID:1367115;
NZBNAME:The Dark Knight Rises 2012 V3 FRENCH TS LD XViD 73v3n;
LINK:nzbmatrix.com/nzb-details.php?id=1367115&hit=1;
SIZE:1660598353.92;
INDEX_DATE:2012-08-27 08:58:12;
USENET_DATE:2012-08-25 6:35:43;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.divx.french;
COMMENTS:0;
HITS:0;
NFO:;
WEBLINK:http://www.imdb.com/title/tt1345836;
LANGUAGE:French;
IMAGE:http://img594.imageshack.us/img594/6128/7t4st.jpg;
REGION:0;
|
NZBID:1345375;
NZBNAME:The Dark Knight Rises 2012 TS NEW SOURCE XViD UNiQUE;
LINK:nzbmatrix.com/nzb-details.php?id=1345375&hit=1;
SIZE:2346671144.96;
INDEX_DATE:2012-08-01 20:07:35;
USENET_DATE:2012-08-01 6:19:37;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.xvid;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:;
LANGUAGE:English;
IMAGE:;
REGION:0;
|
NZBID:1345076;
NZBNAME:The Dark Knight Rises 2012 TS NEW SOURCE XViD UNiQUE;
LINK:nzbmatrix.com/nzb-details.php?id=1345076&hit=1;
SIZE:2270387240.96;
INDEX_DATE:2012-08-01 14:24:56;
USENET_DATE:2012-07-31 9:17:38;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.nospam.cheerleaders;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:;
LANGUAGE:English;
IMAGE:;
REGION:0;
|
NZBID:1345066;
NZBNAME:The Dark Knight Rises (2012) TS 480p V2 READNFO (cookieboy);
LINK:nzbmatrix.com/nzb-details.php?id=1345066&hit=1;
SIZE:3179513118.72;
INDEX_DATE:2012-08-01 14:17:48;
USENET_DATE:2012-08-01 11:49:30;
CATEGORY:Movies > Other;
GROUP:alt.binaries.movies;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img3.imageshack.us/img3/4155/mv5bmtk4odqzndy3ml5bml5d.jpg;
REGION:0;
|
NZBID:1344276;
NZBNAME:The Dark Knight Rises 2012 TS FULL NeW SOURCE READNFO XviD   ILLUMINATI;
LINK:nzbmatrix.com/nzb-details.php?id=1344276&hit=1;
SIZE:2491636776.96;
INDEX_DATE:2012-07-31 18:00:27;
USENET_DATE:2012-07-31 5:23:17;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.nospam.cheerleaders;
COMMENTS:2;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img801.imageshack.us/img801/9734/4fcf126f5dac2.jpg;
REGION:0;
|
NZBID:1344172;
NZBNAME:The Dark Knight Rises (2012) TS Line Audio XviD Uncut;
LINK:nzbmatrix.com/nzb-details.php?id=1344172&hit=1;
SIZE:1970557419.52;
INDEX_DATE:2012-07-31 11:56:50;
USENET_DATE:2012-07-31 11:34:07;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.xvid;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img860.imageshack.us/img860/8452/mv5bmtk4odqzndy3ml5bml5.jpg;
REGION:0;
|
NZBID:1343260;
NZBNAME:The Dark Knight Rises 2012 CAM Line Audio Devildeeds74;
LINK:nzbmatrix.com/nzb-details.php?id=1343260&hit=1;
SIZE:1866255564.8;
INDEX_DATE:2012-07-30 15:15:26;
USENET_DATE:2012-07-30 2:31:56;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.boneless;
COMMENTS:0;
HITS:0;
NFO:;
WEBLINK:;
LANGUAGE:English;
IMAGE:;
REGION:0;
|
NZBID:1343197;
NZBNAME:The Dark Knight Rises 2012 TRUEFRENCH CAM MD XviD BLOODYMARY;
LINK:nzbmatrix.com/nzb-details.php?id=1343197&hit=1;
SIZE:1678109573.12;
INDEX_DATE:2012-07-30 13:39:46;
USENET_DATE:2012-07-27 8:03:07;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.divx.french;
COMMENTS:0;
HITS:0;
NFO:;
WEBLINK:;
LANGUAGE:French;
IMAGE:;
REGION:0;
|
NZBID:1343193;
NZBNAME:The Dark Knight Rises 2012 TRUEFRENCH REPACK TS MD XviD PARADIS;
LINK:nzbmatrix.com/nzb-details.php?id=1343193&hit=1;
SIZE:838399426.56;
INDEX_DATE:2012-07-30 13:36:32;
USENET_DATE:2012-07-29 11:30:58;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.divx.french;
COMMENTS:0;
HITS:0;
NFO:;
WEBLINK:;
LANGUAGE:French;
IMAGE:;
REGION:0;
|
NZBID:1340660;
NZBNAME:The Dark Knight Rises 2012 TS XViD INSPiRAL;
LINK:nzbmatrix.com/nzb-details.php?id=1340660&hit=1;
SIZE:2648472289.28;
INDEX_DATE:2012-07-27 23:36:12;
USENET_DATE:2012-07-27 11:23:14;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.divx;
COMMENTS:1;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img705.imageshack.us/img705/8452/mv5bmtk4odqzndy3ml5bml5.jpg;
REGION:0;
|
NZBID:1340478;
NZBNAME:The Dark Knight Rises 2012 New Version German FW;
LINK:nzbmatrix.com/nzb-details.php?id=1340478&hit=1;
SIZE:2281229516.8;
INDEX_DATE:2012-07-27 16:12:38;
USENET_DATE:2012-07-27 9:46:21;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.divx;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:;
LANGUAGE:German;
IMAGE:;
REGION:0;
|
NZBID:1339461;
NZBNAME:The Dark Knight Rises (2012) TS AC3 5 1 CrEwSaDe;
LINK:nzbmatrix.com/nzb-details.php?id=1339461&hit=1;
SIZE:701633658.88;
INDEX_DATE:2012-07-26 16:53:12;
USENET_DATE:2012-07-26 3:58:03;
CATEGORY:Movies > Other;
GROUP:alt.binaries.movies;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img801.imageshack.us/img801/9734/4fcf126f5dac2.jpg;
REGION:0;
|
NZBID:1339448;
NZBNAME:The Dark Knight Rises (2012) TS MD V2 READNFO German XviD Suicide;
LINK:nzbmatrix.com/nzb-details.php?id=1339448&hit=1;
SIZE:2666140794.88;
INDEX_DATE:2012-07-26 16:09:32;
USENET_DATE:2012-07-26 3:41:54;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.mom;
COMMENTS:0;
HITS:3;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:German;
IMAGE:http://img801.imageshack.us/img801/9734/4fcf126f5dac2.jpg;
REGION:0;
|
NZBID:1338279;
NZBNAME:The Dark Knight Rises 2012 TS XViD UNiQUE;
LINK:nzbmatrix.com/nzb-details.php?id=1338279&hit=1;
SIZE:2112031293.44;
INDEX_DATE:2012-07-25 22:17:18;
USENET_DATE:2012-07-25 9:11:03;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.boneless;
COMMENTS:1;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img841.imageshack.us/img841/8452/mv5bmtk4odqzndy3ml5bml5.jpg;
REGION:0;
|
NZBID:1338079;
NZBNAME:The Dark Knight Rises (2012) CAM RIP WDR;
LINK:nzbmatrix.com/nzb-details.php?id=1338079&hit=1;
SIZE:1374861393.92;
INDEX_DATE:2012-07-25 13:55:06;
USENET_DATE:2012-07-25 1:25:08;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img861.imageshack.us/img861/3961/thedarkknightrisesl.jpg;
REGION:0;
|
NZBID:1338052;
NZBNAME:The Dark Knight Rises (2012) READNFO CAM XviD BBnRG;
LINK:nzbmatrix.com/nzb-details.php?id=1338052&hit=1;
SIZE:2767947038.72;
INDEX_DATE:2012-07-25 11:58:23;
USENET_DATE:2012-07-25 11:39:46;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.xvid;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img820.imageshack.us/img820/2814/thedarkknightrisesh.jpg;
REGION:0;
|
NZBID:1338029;
NZBNAME:The Dark Knight Rises 2012 CAM AUDIO V2 AC3 H264 CRYS;
LINK:nzbmatrix.com/nzb-details.php?id=1338029&hit=1;
SIZE:829580902.4;
INDEX_DATE:2012-07-25 10:19:15;
USENET_DATE:2012-07-25 9:37:48;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies;
COMMENTS:3;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img23.imageshack.us/img23/9892/mv5bmtk4odqzndy3ml5bml5q.jpg;
REGION:0;
|
NZBID:1338001;
NZBNAME:The Dark Knight Rises (2012) Cam NEW AUDIO XviD RESiSTANCE *DiffGroup*;
LINK:nzbmatrix.com/nzb-details.php?id=1338001&hit=1;
SIZE:2254344028.16;
INDEX_DATE:2012-07-25 09:57:06;
USENET_DATE:2012-07-25 9:34:19;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img713.imageshack.us/img713/4337/32473753.jpg;
REGION:0;
|
NZBID:1337978;
NZBNAME:Batman The Dark Knight Rises (2012) CAM Xvid miRaGe;
LINK:nzbmatrix.com/nzb-details.php?id=1337978&hit=1;
SIZE:1588236124.16;
INDEX_DATE:2012-07-25 09:29:37;
USENET_DATE:2012-07-25 9:05:50;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.xvid;
COMMENTS:1;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:http://img43.imageshack.us/img43/5703/f26d8350b3.jpg;
REGION:0;
|
NZBID:1337967;
NZBNAME:The Dark Knight Rises 2012 CAM NEW 550MB;
LINK:nzbmatrix.com/nzb-details.php?id=1337967&hit=1;
SIZE:656534405.12;
INDEX_DATE:2012-07-25 09:18:51;
USENET_DATE:2012-07-25 9:06:04;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:English;
IMAGE:;
REGION:0;
|
NZBID:1337931;
NZBNAME:The Dark Knight Rises 2012 CAM NEW AUDIO XviD RESiSTANCE;
LINK:nzbmatrix.com/nzb-details.php?id=1337931&hit=1;
SIZE:2183711948.8;
INDEX_DATE:2012-07-25 08:13:46;
USENET_DATE:2012-07-24 10:25:18;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:;
LANGUAGE:English;
IMAGE:;
REGION:0;
|
NZBID:1337091;
NZBNAME:Hans Zimmer The Dark Knight Rises OST CD 2012;
LINK:nzbmatrix.com/nzb-details.php?id=1337091&hit=1;
SIZE:92190801.92;
INDEX_DATE:2012-07-24 17:34:21;
USENET_DATE:2012-07-24 11:14:12;
CATEGORY:Music > MP3 Albums;
GROUP:alt.binaries.cavebox;
COMMENTS:0;
HITS:0;
NFO:no;
WEBLINK:;
LANGUAGE:NA;
IMAGE:;
REGION:0;
|
NZBID:1336901;
NZBNAME:The Dark Knight Rises 2012 CAM NEW XVID 26K;
LINK:nzbmatrix.com/nzb-details.php?id=1336901&hit=1;
SIZE:2700041256.96;
INDEX_DATE:2012-07-24 15:36:10;
USENET_DATE:2012-07-24 5:31:26;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.boneless;
COMMENTS:0;
HITS:0;
NFO:;
WEBLINK:;
LANGUAGE:NA;
IMAGE:;
REGION:0;
|
NZBID:1336854;
NZBNAME:Hans Zimmer The Dark Knight Rises OST CD FLAC 2012 FRAY;
LINK:nzbmatrix.com/nzb-details.php?id=1336854&hit=1;
SIZE:299903221.76;
INDEX_DATE:2012-07-24 11:21:03;
USENET_DATE:2012-07-24 11:25:14;
CATEGORY:Music > Lossless;
GROUP:alt.binaries.sounds.flac;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:;
LANGUAGE:English;
IMAGE:;
REGION:0;
|
NZBID:1336841;
NZBNAME:Hans Zimmer The Dark Knight Rises OST CD 2012 FRAY;
LINK:nzbmatrix.com/nzb-details.php?id=1336841&hit=1;
SIZE:97465139.2;
INDEX_DATE:2012-07-24 10:40:40;
USENET_DATE:2012-07-24 10:46:41;
CATEGORY:Music > MP3 Albums;
GROUP:alt.binaries.inner-sanctum;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.mp3dev.org/) -V0;
LANGUAGE:NA;
IMAGE:;
REGION:0;
|
NZBID:1336807;
NZBNAME:The Dark Knight Rises (2012) Hindi Scam Untouched;
LINK:nzbmatrix.com/nzb-details.php?id=1336807&hit=1;
SIZE:575217336.32;
INDEX_DATE:2012-07-24 09:12:50;
USENET_DATE:2012-07-24 8:31:04;
CATEGORY:Movies > Other;
GROUP:alt.binaries.movies;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:Hindi;
IMAGE:http://img35.imageshack.us/img35/3606/41049xjtuuvuljpegtn.jpg;
REGION:0;
|
NZBID:1336796;
NZBNAME:The Dark Knight Rises (2012) Hindi Scam Untouched;
LINK:nzbmatrix.com/nzb-details.php?id=1336796&hit=1;
SIZE:575217336.32;
INDEX_DATE:2012-07-24 08:53:17;
USENET_DATE:2012-07-24 8:31:04;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt1345836/;
LANGUAGE:Hindi;
IMAGE:http://img21.imageshack.us/img21/428/thedarkknightriseswallp.jpg;
REGION:0;
|
END_BBB

my $possession_data = <<'END_CCC';
NZBID:1379866;
NZBNAME:The Possession (2012) CAM XviD BBnRG;
LINK:nzbmatrix.com/nzb-details.php?id=1379866&hit=1;
SIZE:914484101.12;
INDEX_DATE:2012-09-11 15:13:48;
USENET_DATE:2012-09-11 2:27:15;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.xvid;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt0431021/;
LANGUAGE:English;
IMAGE:http://img685.imageshack.us/img685/2190/thepossession.jpg;
REGION:0;
|
NZBID:1378534;
NZBNAME:The Possession (2012) TS Xvid   UnKnOwN;
LINK:nzbmatrix.com/nzb-details.php?id=1378534&hit=1;
SIZE:1109770895.36;
INDEX_DATE:2012-09-10 01:19:05;
USENET_DATE:2012-09-10 12:13:19;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.nospam.cheerleaders;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt0431021/;
LANGUAGE:English;
IMAGE:http://img24.imageshack.us/img24/6274/mv5bmtc0ntcxmdu0mv5bml5.jpg;
REGION:0;
|
NZBID:1377647;
NZBNAME:The Possession 2012 Cam Rip XviD FANTA;
LINK:nzbmatrix.com/nzb-details.php?id=1377647&hit=1;
SIZE:1691709603.84;
INDEX_DATE:2012-09-09 05:06:48;
USENET_DATE:2012-09-09 4:50:43;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.nospam.cheerleaders;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt0431021/;
LANGUAGE:English;
IMAGE:http://img40.imageshack.us/img40/6274/mv5bmtc0ntcxmdu0mv5bml5.jpg;
REGION:0;
|
NZBID:1377607;
NZBNAME:The Possession 2012 Cam Rip XviD FANTA;
LINK:nzbmatrix.com/nzb-details.php?id=1377607&hit=1;
SIZE:1594213007.36;
INDEX_DATE:2012-09-09 03:41:56;
USENET_DATE:2012-09-08 10:58:06;
CATEGORY:Movies > Divx/Xvid;
GROUP:alt.binaries.movies.divx;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:http://www.imdb.com/title/tt0431021/;
LANGUAGE:English;
IMAGE:;
REGION:0;
|
NZBID:1307889;
NZBNAME:Hats Barn Voices of the Ultimate Possession 2012 GRAVEWISH;
LINK:nzbmatrix.com/nzb-details.php?id=1307889&hit=1;
SIZE:87115694.08;
INDEX_DATE:2012-06-17 10:07:57;
USENET_DATE:2012-06-17 10:14:54;
CATEGORY:Music > MP3 Albums;
GROUP:alt.binaries.inner-sanctum;
COMMENTS:0;
HITS:0;
NFO:yes;
WEBLINK:;
LANGUAGE:NA;
IMAGE:;
REGION:0;
|
END_CCC

my %search_data = (
  "Assault on Precinct 13 1976" => $assault_data,
  "The Dark Knight Rises 2012" => $darkknight_data,
  "The Possession 2012" => $possession_data,
);

method get ($uri) {
    $self->_set_searches_remaining($self->searches_remaining - 1);
    my $data = $search_data{ $uri->query_param('search') };
    return HTTP::Response->new(200, 'OK',
        HTTP::Headers->new(
            API_Rate_Limit_Left => $self->searches_remaining,
        ),
        $data // 'error:nothing_found',
    );
}

__PACKAGE__->meta->make_immutable;
1;
