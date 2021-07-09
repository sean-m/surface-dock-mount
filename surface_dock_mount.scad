/*
h 70.2
w 130
d 30

8.5 channel extending 40 mm down right side

10 x 45 opening on bottom, starting 5 mm from left side
*/

wiggle = 1.2;

mh = 70.2;
mw = 130 + wiggle;
md = 30 + wiggle;

wall_thickness = 2;

side_notch_tall = 40;
side_notch_width = 9;

bh_end = 3;
bhw = 120;
bhw = mw - (2*bh_end);
bhd = 25;

screw_size = 5;

module mainBody() {
    difference() {
        oversize = 2 * wall_thickness;
        cube([mw + oversize, md + oversize, mh + wall_thickness]);
        translate([wall_thickness,wall_thickness,wall_thickness])
            cube([mw, md, mh+1]);
    }
}

module sideNotch(size, tall) {
    translate([0,0,size/2])
        cube([wall_thickness+2, size, tall-(size/2)]);
    difference() {
        translate([0,size/2,size/2]) rotate([0,90,0]) cylinder(wall_thickness + 2, d=size);
        translate([0,0,size/2])
            cube([wall_thickness+2, size, size]);
    }
}

module bottomNotch() {
    notch_size = 15;
    translate([0,notch_size,0])
        sphere(notch_size);
}

module bottomHole() {
    translate([bhd/2, bhd/2, 0]) cylinder(wall_thickness+1, d=bhd);
    translate([bhd/2, 0, 0]) cube([bhw-bhd, bhd, wall_thickness+1]);
    translate([bhw-(bhd/2), bhd/2, 0]) cylinder(wall_thickness+1, d=bhd);
}


module bottomHole2() {
    minkowski() {
    
        linear_extrude(wall_thickness + 1) {
            translate([bhd/2, bhd/2, 0]) circle(d=bhd);
            translate([bhd/2, 0, 0]) square([bhw-bhd, bhd]);
            translate([bhw-(bhd/2), bhd/2, 0]) circle(d=bhd);
        }
        rotate_extrude()polygon([ [0,0] , [4, -8], [0, -8] ]);
    }
}


module screwTab() {
    tx = 18;
    ty = 30;
    tt = wall_thickness * 2;
    
    module tabBody() {
        rotate([90,0,0])
            translate([0,0,-tt])
                linear_extrude(tt)
                    polygon(points = [ [0, ty], [tx, ty], [tx, 0] ]);
        translate([0,0,ty])
            cube([tx, tt, ty]);
    }
    
    difference() {
        tabBody();
        
        rotate([90,0,0])
            translate([tx/2,ty,-tt])
                cylinder(tt, d=screw_size);
        rotate([90,0,0])
            translate([tx/2,ty+20,-tt])
                cylinder(tt, d=screw_size);
    }
}


module thing() {
    $fn=64;
    
    // housing body, shifted to accomodate screw tabs
    translate([18,0,0]) {
        difference() {
            
            /* */
            mainBody();
            
            translate([0,wall_thickness+(md/2)-(side_notch_width/2),(mh+wall_thickness)-side_notch_tall])
                sideNotch(10, side_notch_tall);
            
            translate([mw + wall_thickness - 1,(wall_thickness+(md/2)-(side_notch_width/2)),(mh+wall_thickness)-side_notch_tall])
                sideNotch(10, side_notch_tall);
            /*
            translate([wall_thickness+mw/2,-(md/2),0])
                bottomNotch();
            */
            bottom_hole_shift = (md/2) - (bhd/2) + wall_thickness;
            translate([(mw+wall_thickness)-bhw-bh_end,bottom_hole_shift,0])
                bottomHole2();
            
            
            rotate([90,0,0])
                translate([mw/2 + wall_thickness,100,0])
                    cylinder(100, d=mw*1.09, center=true);

        }
    }
    
    // left tab
    translate([0,md,10])
        screwTab();
    
    // right tab
    translate([mw+(wall_thickness*2)+18*2,md,10])            
        mirror()
            screwTab();
}
thing();










