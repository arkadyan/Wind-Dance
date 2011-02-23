document.domain='wunderground.com';
var googlemap;


var infowindowinprogress=false;
var ignoremoveend=false;
var iconmode='tw';
var units='english';
var current_marker;


var has_static_marker=false;
var static_marker_lat=0;
var static_marker_lon=0;
var static_marker_text=0;
var static_marker_icon=0;

var auto_zoom_out=false;


/*
GMap.prototype.addOverlays=function(a){
        var b=this;
        var i=0;
        for (i=0;i<a.length;i++) {
                try {
                        this.overlays.push(a[i]);
                        a[i].initialize(this);
                        a[i].redraw(true);
                } catch(ex) {
                        alert('err: ' + i + ', ' + ex.toString());
                }
        }
        this.reOrderOverlays();
};
*/



function lookupWindString(n)
{
	var s="-";

	if (n > 360) n = n%360;

	if (n >= 0      && n < 11.25 ) s="N";
	else if (n >= 11.25  && n < 33.75 ) s="NNE";
	else if (n >= 33.75  && n < 56.25 ) s="NE";
	else if (n >= 67.5   && n < 78.75 ) s="ENE";
	else if (n >= 78.75  && n < 101.25) s="E";
	else if (n >= 101.25 && n < 123.75) s="ESE";
	else if (n >= 123.75 && n < 146.25) s="SE";
	else if (n >= 146.2  && n < 168.75) s="SSE";
	else if (n >= 168.75 && n < 191.25) s="S";
	else if (n >= 191.25 && n < 213.75) s="SSW";
	else if (n >= 213.75 && n < 236.25) s="SW";
	else if (n >= 236.25 && n < 258.75) s="WSW";
	else if (n >= 258.75 && n < 281.25) s="W";
	else if (n >= 281.25 && n < 303.75) s="WNW";
	else if (n >= 303.75 && n < 326.25) s="NW";
	else if (n >= 326.25 && n < 348.75) s="NNW";
	else if (n >= 348.75) s="N";

	return s;
}



function convertTempIntoUnits(u,t) {
	if (t =='-999' || t =='-9999') return '-';
	if (u=='both' || u=='english') return t;
	return parseInt((t-32)/1.8);
}



function convertWindIntoUnits(u,w) {
	var m = w/2.237*3.6;
	if (u=='metric')
		return parseInt(m);
	else
		return w;
}

function  convertPressureIntoUnits(u,p) {
	if (u=='metric')
		return parseInt(p* 33.86);
	else
		return p;
}


function convertRainIntoUnits(u,r) {
	if (u=='metric')
		return parseInt(r*2.54*10)/10.0;
	else
		return r;
}


function LoadMapWithMarker(lat, lon, units, zoom, mlat, mlon, mtext, micon)
{
	googlemap = new GMap(document.getElementById("map"));
	googlemap.setMapType(G_HYBRID_MAP);
	auto_zoom_out=true;
    googlemap.addControl(new GSmallMapControl());
    googlemap.addControl(new GMapTypeControl());
    googlemap.centerAndZoom(new GPoint(lon,lat), zoom);

    GEvent.addListener(googlemap, "moveend", function() { if (ignoremoveend==true) ignoremoveend=false; else  DoMap(googlemap);});
    GEvent.addListener(googlemap, "movestart", function() { if (infowindowinprogress==true) ignoremoveend=true;});
    GEvent.addListener(googlemap, "infowindowopen", function() {  infowindowinprogress=false;});

	has_static_marker=true;
	static_marker_lat=mlat;
	static_marker_lon=mlon;
	static_marker_text=mtext;
	static_marker_icon=micon;

	DoMap(googlemap);
}

function LoadMap(lat, lon, punits) {
//	var lat = 37.8; 
//	var lon = -122.4; 
	var zoom = 4;
	
	units=punits;

	googlemap = new GMap(document.getElementById("map"));
        googlemap.addControl(new GSmallMapControl());
        googlemap.addControl(new GMapTypeControl());
        googlemap.centerAndZoom(new GPoint(lon,lat), zoom);

        GEvent.addListener(googlemap, "moveend", function() { if (ignoremoveend==true) ignoremoveend=false; else  DoMap(googlemap);});
        GEvent.addListener(googlemap, "movestart", function() { if (infowindowinprogress==true) ignoremoveend=true;});
        GEvent.addListener(googlemap, "infowindowopen", function() {  infowindowinprogress=false;});

	DoMap(googlemap);
}


function createMarker(point, html, mode, tu,t, wsu,ws, wd, tdu,td, h, ru,r, wx) {

        var icon = new GIcon();
        icon.iconSize = new GSize(64, 64);
        icon.shadowSize = new GSize(64, 64);
        icon.iconAnchor = new GPoint(32, 32);
        icon.infoWindowAnchor = new GPoint(32,32);
        icon.infoShadowAnchor = new GPoint(32,32);
        icon.image = "http://stationicon.wunderground.com/cgi-bin/gmapicon?mode=" + mode + "&t=" + t +"&tu="+tu + "&ws=" + ws +"&wsu="+wsu + "&wd=" + wd + "&td="+td+ "&tdu="+tdu+"&h="+h+"&r="+r +"&ru="+ru+ "&wx=" + wx +"&format=.png";
        icon.shadow= "http://stationicon.wunderground.com/gmapshadow.png";
        icon.imageMap = new Array(22,22,38,22,38,38,22,38,22,22);
        icon.transparent= "http://stationicon.wunderground.com/gmapicon.png";
        var marker = new GMarker(point, icon);
		marker.myclickfunction= function() { current_marker = marker; infowindowinprogress=true;
                    ignoremoveend=true; marker.html=html; marker.openInfoWindowTabsHtml([new GInfoWindowTab(LANG["kLang.DateTime.Current"],marker.html)]); };
        GEvent.addListener(marker, "click", marker.myclickfunction);

        return marker;
}



function DoMap(map) {

	var bounds = map.getBoundsLatLng();
	var frag='http://stationdata.wunderground.com/cgi-bin/stationdata?maxlat='+bounds.maxY+'&minlat='+bounds.minY+'&maxlon='+ bounds.maxX+'&minlon='+ bounds.minX +'&iframe=1';

	var scriptarray=document.getElementsByTagName('iframe');
	document.getElementById('stationscript').src=frag;
}



function addStaticMarker()
{
	var map=googlemap;
	if (has_static_marker)
	{
	//	static_marker_lat=mlat;
	//	static_marker_lon=mlon;
	//	static_marker_text=mtext;
	//	static_marker_icon=micon;

        var icon = new GIcon();
        icon.iconSize = new GSize(64, 64);
        icon.shadowSize = new GSize(64, 64);
        icon.iconAnchor = new GPoint(32, 32);
        icon.infoWindowAnchor = new GPoint(32,32);
        icon.infoShadowAnchor = new GPoint(32,32);
        icon.image = static_marker_icon;
        icon.shadow= "http://stationicon.wunderground.com/gmapshadow.png";
        icon.imageMap = new Array(22,22,38,22,38,38,22,38,22,22);
        icon.transparent= "http://stationicon.wunderground.com/gmapicon.png";
		var point = new GPoint(static_marker_lon,static_marker_lat);
        //var marker = new GMarker(point, icon);
        var marker = new GMarker(point );
        marker.myclickfunction= function() { current_marker = marker; infowindowinprogress=true; 
                                        ignoremoveend=true; marker.html=static_marker_text;  marker.openInfoWindowHtml(static_marker_text); };
        GEvent.addListener(marker, "click", marker.myclickfunction);

		map.addOverlay(marker);
	}	
}

function MapCallback(weatherStations) {
        var map=googlemap;
        var bounds = map.getBoundsLatLng();

        var now = new Date();
        var year = now.getYear() + 1900;
        var month = now.getMonth();
        var day = now.getDate();

        if (!weatherStations || !weatherStations.length) {

		addStaticMarker();

		//
		// automatically zoom out
		//
			if (auto_zoom_out)
			{
				map.zoomTo(map.getZoomLevel()+1);
			}

                return;
        }
		else
		{
			auto_zoom_out=false;
		}

        var markers = new Array(weatherStations.length);
        var html = new Array(weatherStations.length);

	var m = new Array( weatherStations.length );

        //  clear the overlays at the last possible moment so we don't have as much of a flash
        map.clearOverlays(m);

	for (var i=0; i<weatherStations.length; ++i ){
		var lat = parseFloat(weatherStations[i]['lat']).toFixed(5);
		var lon = parseFloat(weatherStations[i]['lon']).toFixed(5);
		var id = weatherStations[i]['id'];
		var elev = weatherStations[i]['elev'];
		if(elev == '-9999') {
			elev = 'n/a';
		} else {
			elev = elev + ' ft';
		}

		var tempf = weatherStations[i]['tempf'];
		var temp = convertTempIntoUnits(units,tempf);
		var tempUnit = (units =='metric') ? 'C' : 'F';


		var winddir = weatherStations[i]['winddir'];
		var winddirstring=lookupWindString(winddir);

		var windspdmph = weatherStations[i]['windspeedmph'];
		var windspd = convertWindIntoUnits(units,windspdmph);
		var windspdUnit = (units =='metric') ? 'km/h' : 'mph';

		var neighborhood = weatherStations[i]['neighborhood'];
		var adm1 = weatherStations[i]['adm1'];
		var name = neighborhood;
		var type = weatherStations[i]['type'];
		var weather = "";
		if(type != 'PWS') {
			name = weatherStations[i]['name'];	
			weather = weatherStations[i]['weather'];
		} else {
			if(neighborhood == '' || neighborhood == 'NULL') {
				name = adm1;
			}
		}

		var dewpointf = weatherStations[i]['dewptf'];
		var dewpoint= convertTempIntoUnits(units,dewpointf);
		var dewpointUnit= (units =='metric') ? 'C' : 'F';


		var humidity = weatherStations[i]['humidity'];
		if (humidity =='-999') humidity='-';
		if (humidity =='N/A') humidity='-';

		var pressurein = weatherStations[i]['baromin'];
		var pressure = convertPressureIntoUnits(units,pressurein);
		var pressureUnit= (units=='metric') ? 'hPa' : 'in';

		var rainin= weatherStations[i]['rainin'];
		var rain= convertRainIntoUnits(units,rainin);
		var rainUnit = (units=='metric') ? 'cm' : 'in';
		var dailyrainin= weatherStations[i]['dailyrainin'];
		var dailyrain= convertRainIntoUnits(units,dailyrainin);

		if (rainin <= -999)
		{
			rainin="-";
			rain="-";
		}
		if (dailyrainin <= -999)
		{
			dailyrainin="-";
			dailyrain="-";
		}
		markers[i] = new GPoint(lon,lat);

		var linestyle = '\"font-family: Verdana, Geneva, Arial, Helvetica, sans-serif; font-size: 9px;\"';

		var history_link_str = "";

		if(type == 'ICAO')
		{
				history_link_str = "/history/airport/" + id + "/" + year + "/" + (month+1) + "/" + day + "/DailyHistory.html";
		}
		else if (type=='SYNOP')
		{
				history_link_str = "/history/station/" + id + "/" + year + "/" + (month+1) + "/" + day + "/DailyHistory.html";
		}
		else if (type=='BUOY')
		{
				//remove the BUOY
				var real_id = id.substr(4);
				history_link_str = "/MAR/buoy/" + real_id +".html";
		}
		else if (type=='PWS')
		{
				history_link_str = "/weatherstation/WXDailyHistory.asp?ID="+id;
		}



		html[i] = "<div page=\"1\" label=\""+LANG["kLang.DateTime.Current"]+"\" class=\"active\" style=\"font-family: Verdana, Geneva, Arial, Helvetica, sans-serif; font-size: 9px;\">" +
		"<div style=\"padding-bottom: 2px; font-weight: bold; border-bottom: 1px solid #CCC;\"><a href=\""+history_link_str+"\">" +  name + "</a></div>" +
		"<table cellspacing=\"0\" cellpadding=\"2\">" +
		"<tr><td><div style="+linestyle+">Temperature:</div></td><td><div style="+linestyle+">"+temp+" &deg;"+tempUnit+"</div></td></tr>" +
		"<tr><td><div style="+linestyle+">Dewpoint:</div></td><td><div style="+linestyle+">"+dewpoint+" &deg;"+dewpointUnit+"</div></td></tr>" +
		"<tr><td><div style="+linestyle+">Humidity:</div></td><td><div style="+linestyle+">"+humidity+"%</div></td></tr>";

		if (windspdmph==0) {
			html[i]+="<tr><td><div style="+linestyle+">Wind:</div></td><td><div style="+linestyle+">Calm</div></td></tr>";
		} else {
			html[i]+="<tr><td><div style="+linestyle+">Wind:</div></td><td><div style="+linestyle+">"+winddirstring+" at "+windspd+windspdUnit+"</div></td></tr>";
		}
		html[i]+="<tr><td><div style="+linestyle+">Pressure:</div></td><td><div style="+linestyle+">"+pressure+pressureUnit+"</div></td></tr>" +
			"<tr><td><div style="+linestyle+">Precipitation:</div></td><td><div style="+linestyle+">"+ rain +rainUnit+"/hr</div></td></tr>" +
		"<tr><td><div style="+linestyle+">Daily Precip.:</div></td><td><div style="+linestyle+">"+ dailyrain +rainUnit+"</div></td></tr>" +
		"</table>" +
		"</div>";

		m[i] = createMarker(markers[i], html[i], iconmode, temp,tempf,  windspd,windspdmph, winddir, dewpoint,dewpointf, humidity, rain,rainin, weather);


		map.addOverlay(m[i]);
	}

		addStaticMarker();
        //map.addOverlays(m);

        for (var i=0; i<weatherStations.length; ++i ){
		weatherStations[i] = null;
	}
}
//]]>
