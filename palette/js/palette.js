
var picker = document.getElementById("picker");
var ctx = picker.getContext("2d");

var palette = document.getElementById("myCanvas");
var context = palette.getContext("2d");

var colorChosen = "black";
var image = new Image();
image.src = 'assets/palette.jpg';
image.onload = function(){
	ctx.drawImage(this,0,0); // this fait référence à l'objet courant (=image)
};
    
picker.addEventListener('mousedown', function(ev) {
    var x = ev.layerX - 5;
    var y = ev.layerY - 5;// + (palette.height - picker.height);
    var pixeldata = ctx.getImageData(x, y, 1, 1);
    var col = pixeldata.data;
    colorChosen = 'rgba(' +
        col[0] + ',' + col[1] + ',' +
        col[2] + ',' + col[3] + ')';
}, false );
   
var mousedown = false;
function draw(ev) {
   if (mousedown) {
     var x = ev.layerX ;//- picker.width - 10;
     var y = ev.layerY - 10;
	context.lineTo(x,y);
	context.stroke();
   }
 }
palette.addEventListener('mousemove', draw , false);

palette.addEventListener('mousedown', function(ev) {
     var x = ev.layerX ;//- picker.width - 10;
     var y = ev.layerY - 10;
    mousedown = true;
	context.beginPath();
	context.moveTo(x,y);
	context.lineWidth = 5;
	context.lineJoin = "round";
	context.lineCap = "round";
	context.strokeStyle = colorChosen;
}, false );

palette.addEventListener('mouseup', function(ev) {
   mousedown = false;
	context.closePath();
}, false );
