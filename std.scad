thick=18;
rounding=1;

module planeFront(dim, l=0,r=0,t=0,b=0, ll=0,rr=0,tt=0,bb=0, thick=thick) {
    coords = __planeFront(dim, l,r,t,b, ll,rr,tt,bb, thick);
    echo("plane (front): ", coords[2]);
    translate(coords[1]) __rcube(coords[0]);
}
module planeBack(dim, l=0,r=0,t=0,b=0, ll=0,rr=0,tt=0,bb=0, thick=thick) {
    coords = __planeFront(dim, l,r,t,b, ll,rr,tt,bb, thick);
    echo("plane (back): ", coords[2]);
    translate([0, dim[1]-thick, 0]) translate(coords[1]) __rcube(coords[0]);
}
module planeLeft(dim, f=0,B=0,t=0,b=0, ff=0,BB=0,tt=0,bb=0, thick=thick) {
    coords = __planeLeft(dim, f,B,t,b, ff,BB,tt,bb, thick);
    echo("plane (left): ", coords[2]);
    translate(coords[1]) __rcube(coords[0]);
}
module planeRight(dim, f=0,B=0,t=0,b=0, ff=0,BB=0,tt=0,bb=0, thick=thick) {
    coords = __planeLeft(dim, f,B,t,b, ff,BB,tt,bb, thick);
    echo("plane (right): ", coords[2]);
    translate([dim[0]-thick, 0, 0]) translate(coords[1]) __rcube(coords[0]);
}
module planeBottom(dim, l=0,r=0,f=0,B=0,ll=0,rr=0,ff=0,BB=0, thick=thick) {
    coords = __planeBottom(dim, l,r,f,B, ll,rr,ff,BB, thick);
    echo("plane (bottom): ", coords[2]);
    translate(coords[1]) __rcube(coords[0]);
}
module planeTop(dim, l=0,r=0,f=0,B=0,ll=0,rr=0,ff=0,BB=0, thick=thick) {
    coords = __planeBottom(dim, l,r,f,B, ll,rr,ff,BB, thick);
    echo("plane (top): ", coords[2]);
    translate([0, 0, dim[2]-thick]) translate(coords[1]) __rcube(coords[0]);
}

/**
For exmaple 4 legs:
 leg(drawer, legHeight, l=2, f=3);
 leg(drawer, legHeight, r=2, f=3);
 leg(drawer, legHeight, l=2, B=2);
 leg(drawer, legHeight, r=2, B=2);
*/
module leg(dim, legHeight, l=0,r=0,f=0,B=0,ll=0,rr=0,ff=0,BB=0, thick=thick) {
    translate([
        if(r!=0 || rr != 0) dim[0] else 0,
        if(B!=0 || BB != 0) dim[1] else 0,
        0
    ])
    translate([
        l*thick-r*thick-rr,
        f*thick-B*thick-BB,
        0
    ])
    cylinder(legHeight, 9.5, 19.5);
}

module __rcube(dim, rounding=rounding) {
  minkowski() {
    cube(dim-[rounding, rounding, rounding]);
    sphere(rounding/2);
  }
}


function __planeFront(dim, l,r,t,b, ll,rr,tt,bb, thick) = let(
    coords = __planeCoords([dim[0], dim[2]], l,r,b,t, ll,rr,bb,tt, thick)
)[
    [coords[0][0], thick, coords[0][1]],
    [coords[1][0], 0, coords[1][1]],
    coords[2]
];
function __planeLeft(dim, f,B,t,b, ff,BB,tt,bb, thick) = let(
    coords = __planeCoords([dim[1], dim[2]], f,B,b,t, ff,BB,bb,tt, thick)
)[
    [thick, coords[0][0], coords[0][1]],
    [0, coords[1][0], coords[1][1]],
    coords[2]
];
function __planeBottom(dim, l,r,f,B, ll,rr,ff,BB, thick) = let(
    coords = __planeCoords([dim[0], dim[1]], l,r,f,B, ll,rr,ff,BB, thick)
)[
    [coords[0][0], coords[0][1], thick],
    [coords[1][0], coords[1][1], 0],
    coords[2]
];


function __planeCoords(dim, x1, x2, y1, y2, xx1, xx2, yy1, yy2, thick) = let(
    size= [
        dim[0] + x1*thick + x2*thick + xx1 + xx2,
        dim[1] + y1*thick + y2*thick + yy1 + yy2
    ],
    placement=[
        -x1*thick - xx1,
        -y1*thick - yy1
    ]
)[
    size,
    placement,
    str(size[0],"x",size[1],"x",thick)
];