$x("//*[@id='channel_page_all_members']/div").reduce(function(arr,c){
	var name, image, slack;
	slack = $x("./descendant::a[1]/@href",c)[0].nodeValue;
	name = $x(".//a[contains(concat(' ', normalize-space(@class), ' '), ' member ')][last()]/text()",c)[0].nodeValue;
	image = $x("./a/@data-original",c)[0].nodeValue;
	arr.push({
		slack: slack.substr(6),
		name_first: name.split(' ')[0],
		name_last: name.split(' ')[1],
		image: image.substr(5,image.length-9) + "512"
	});
	return arr;
},[]);