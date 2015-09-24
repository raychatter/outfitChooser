window.addEventListener ? 
window.addEventListener("load",colorSVGs,false) : 
window.attachEvent && window.attachEvent("onload",colorSVGs);

function colorSVGs(){
	fillSVG('top-main-color', "top-image", "insideTop");
	fillSVG('bottom-main-color', 'bottom-image', 'InsidePants');
	fillSVG('shoe-main-color', 'shoe-image-left', 'ShoeOutline');
	fillSVG('shoe-main-color', 'shoe-image-right', 'ShoeOutline');
};

function fillSVG(colorId, objectId, selectorToFill) {
	var $colorId = document.getElementById(colorId);
	if($colorId) {
		var $SVGImage = document.getElementById(objectId);
		var SVGDocument = $SVGImage.contentDocument;
		var $SVGItem = SVGDocument.getElementById(selectorToFill);
		$SVGItem.setAttribute("fill", $colorId.textContent);
	}
}
 