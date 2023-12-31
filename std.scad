thick=18;
rounding=2;

module planeFront(
    dim,
    l=0,r=0,t=0,b=0,
    ll=0,rr=0,tt=0,bb=0,
    al=0,ar=0,at=0,ab=0,
    thick=thick
) {
    coords = __planeFront(dim, l,r,t,b, ll-al,rr-ar,tt-ar,bb-ab, thick);
    echo(str("plane (front):\t", __size_with_abs_text(coords[0], al,ar,at,ab,0,0)));
    translate(coords[1]) {
        __abs(coords[0], al,ar,at,ab,0,0);
        cube(coords[0]);
    };
}
module planeBack(
    dim,
    l=0,r=0,t=0,b=0,
    ll=0,rr=0,tt=0,bb=0,
    al=0,ar=0,at=0,ab=0,
    thick=thick
) {
    coords = __planeFront(dim, l,r,t,b, ll-al,rr-ar,tt-at,bb-ab, thick);
    echo(str("plane (back):\t", __size_with_abs_text(coords[0], al,ar,at,ab,0,0)));
    translate([0, dim[1]-thick, 0]) translate(coords[1]) {
        __abs(coords[0], al,ar,at,ab,0,0);
        cube(coords[0]);
    };
}
module planeLeft(
    dim,
    f=0,B=0,t=0,b=0,
    ff=0,BB=0,tt=0,bb=0,
    af=0,aB=0,at=0,ab=0,
    thick=thick
) {
    coords = __planeLeft(dim, f,B,t,b, ff-af,BB-aB,tt-at,bb-ab, thick);
    echo(str("plane (left):\t", __size_with_abs_text(coords[0], 0,0,at,ab,af,aB)));
    translate(coords[1]) {
        __abs(coords[0], 0,0,at,ab,af,aB);
        cube(coords[0]);
    };
}
module planeRight(
    dim,
    f=0,B=0,t=0,b=0,
    ff=0,BB=0,tt=0,bb=0,
    af=0,aB=0,at=0,ab=0,
    thick=thick
) {
    coords = __planeLeft(dim, f,B,t,b, ff-af,BB-aB,tt-at,bb-ab, thick);
    echo(str("plane (right):\t", __size_with_abs_text(coords[0], 0,0,at,ab,af,aB)));
    translate([dim[0]-thick, 0, 0]) translate(coords[1]) {
        __abs(coords[0], 0,0,at,ab,af,aB);
        cube(coords[0]);
    };
}
module planeBottom(
    dim,
    l=0,r=0,f=0,B=0,
    ll=0,rr=0,ff=0,BB=0,
    al=0,ar=0,af=0,aB=0,
    thick=thick
) {
    coords = __planeBottom(dim, l,r,f,B, ll-al,rr-ar,ff-af,BB-aB, thick);
    echo(str("plane (bottom):\t", __size_with_abs_text(coords[0], al,ar,0,0,af,aB)));
    translate(coords[1]) {
        __abs(coords[0], al,ar,0,0,af,aB);
        cube(coords[0]);
    };
}
module planeTop(
    dim,
    l=0,r=0,f=0,B=0,
    ll=0,rr=0,ff=0,BB=0,
    al=0,ar=0,af=0,aB=0,
    thick=thick
) {
    coords = __planeBottom(dim, l,r,f,B, ll-al,rr-ar,ff-af,BB-aB, thick);
    echo(str("plane (top):\t", __size_with_abs_text(coords[0], al,ar,0,0,af,aB)));
    translate([0, 0, dim[2]-thick]) translate(coords[1]) {
        __abs(coords[0], al,ar,0,0,af,aB);
        cube(coords[0]);
    };
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



module __abs(size,l,r,t,b,f,B) {
    translate([-l, 0, -b]) __rcube([l, size[1], size[2]+t+b]);
    translate([-l, -f, -b]) __rcube([size[0]+l+r, f, size[2]+t+b]);
    translate([0, 0, -b]) __rcube([size[0], size[1], b]);
    translate([size[0], 0, -b]) __rcube([r, size[1], size[2]+t+b]);
    translate([-l, size[1], -b]) __rcube([size[0]+l+r, B, size[2]+t+b]);
    translate([0, 0, size[2]]) __rcube([size[0], size[1], t]);
}

function __size_with_abs_text(size,l,r,t,b,f,B) = str(
    size[0],
    size[0] >= size[2] ? __abs_text(f,B) : "",
    size[0] >= size[1] ? __abs_text(t,b) : "",
    " ",chr(215)," ",
    size[1],
    size[1] >= size[2] ? __abs_text(l,r) : "",
    size[1] >= size[0] ? __abs_text(t,b) : "",
    " ",chr(215)," ",
    size[2],
    size[2] >= size[0] ? __abs_text(f,B) : "",
    size[2] >= size[1] ? __abs_text(l,r) : ""
);

function __abs_text(l,r) = l!=0 || r!=0 ? str(
        "(",
        l!=0 ? str(l, r!=0 ? "," : "") : "",
        r!=0 ? str(r) : "",
        ")"
    ) : "";

module __rcube(dim, rounding=rounding) {
    if(dim[0]*dim[1]*dim[2] != 0) {
        __nonCenteredRoundedCube(dim, min(rounding, min(dim)/3));
    }
}
module __nonCenteredRoundedCube(size, radius) {
    z1 = size[2] - radius;
    z2 = radius;
    x = size[0] / 2;
    y = size[1] / 2;
    hull() {
        translate([x, y, z1]) __rectangle(size[0], size[1], radius);
        translate([x, y, z2]) __rectangle(size[0], size[1], radius);
    }
}
module __rectangle(length, width, radius) {
    x = length - radius;
    y = width - radius;
    hull() {
        translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0]) sphere(radius);
        translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0]) sphere(radius);
        translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0]) sphere(radius);
        translate([(x/2)-(radius/2), (y/2)-(radius/2), 0]) sphere(radius);
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