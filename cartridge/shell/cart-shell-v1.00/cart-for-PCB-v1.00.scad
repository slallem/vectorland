
// ========================================================
// VECTREX Cartridge Shell - FOR PCB V1.00
// ========================================================
// OpenSCAD design 2018-2024
// https://github.com/slallem/vectorland
// ========================================================

// 2024-04-18
// As my version 1.00 of PCB has few errors in holes spacing,
// it is not compatible with original game shells.

// This version changes the holes and bits positions
// in order to fit perfectly PCB v1.00.

TODO !

// --------------------------------------------------------
// Parameters
// --------------------------------------------------------

// Common parameters
$fn=32;

// Widths
lar_t   = 74.30;
lar_b   = 73.30;

// Lengths
lon_t   = 72.00; 
lon_b   = 71.15;

// Heights
haut    =  9.60; // Bottom shell height
hautTop = 12.30; // Top shell height
ep      = 2.00; // Shell thickness (v1.0.0=2.3)

// Screw holes and holders

pcb_level     = 11.20;
pcb_top_level = 9.50;

a_diam1    =  9.42;
a_h1       =  4.00;
a_diam2    =  6.90;
a_h2       = pcb_level;
a_diam3    =  5.35; // Important : must fit PCB center hole
a_h3       = 12.76;
a_hole     =  3.20; // Screw goes freely into this hole
a_sh_inset =  2.30; // bottom side screw head inset
a_sh_diam  =  6.30; // bottom side screw head diameter

b_diam1   = 4.97; //Base diameter
b_h1      = pcb_level;
b_diam2   = 3.60; // Important : must fit PCB side holes
b_h2      = a_h3;
b_hole    = 1.50; // Optional / To be checked

c_diam    =  4.80;
c_hole    =  2.00; // Optional / To be checked
c_height  = 12.76;
c_leg_w   =  3.30; // To be checked
c_leg_ep  = c_diam * 0.4; // To be checked
c_leg_h   = pcb_level;

d_diam    = 4.80;
d_hole    = 2.30;
d_height  = pcb_top_level;

e_diam    = 5.15;
e_hole    = 2.30;
e_height  = pcb_top_level;
e_barw    = 7.40;
e_barep   = e_diam * 0.4;

// Joint and bits

joint_h = 6.00;
joint_w = 1.5;

jointspace  = 1.50;
jointstarty = 5.00;

//lockers
jointbit_len = 8.00; //6.00
jointbit_w   = 3.00; //2.30
jointbit_h   = haut;

jointbit_y1 = 32.00; 
jointbit_y2 = 62.00;
jointbit_y3 = lon_t - (ep + jointspace); //TODO: to check
jointbit_x1 = ep + jointspace;
jointbit_x2 = 25.00;
jointbit_x3 = lar_t - jointbit_x2;
jointbit_x4 = lar_t - (ep + jointspace);

// PCB Fence

pcbf_ww = 49.00; //pcb window width
pcbf_fw = 68.18; //fence inside width
pcbf_sw =  9.60; //"sides" width
pcbf_fh = 12.80; // height (fence)
pcbf_wh = pcb_level; //height (window) 11.00
pcbf_y  = 13.50; //position from flat bottom
pcbf_ep = 2.00; //thickness

// Grip

grip_y1     = 49.50; //from flat side
grip_y2     = 65.00; //from flat side
grip_len    = 15.50;
grip_count  =    10; // approx. 24 on original ; too much here (too thin)
grip_size   =  0.90;

// Positionning

y_pinsAB = 22.16;
x_pinA = (lar_t/2);
x_pinB1 = x_pinA - 20.00;
x_pinB2 = x_pinA + 20.00;
x_pinC = 25.60;
y_pinC = lon_t - 19.50;

y_pinE = y_pinsAB;
y_pinsD = lon_t - 21.46;
x_pinD = 14.64;

//top_line_inset = 0.4;
top_line_inset = 1.0;
top_line_y = 26.00;
top_line_ep = 0.6;
top_label_x1 = 2.50;
top_label_x2 = lar_t - top_label_x1;
top_label_y1 = 30.00;
top_label_y2 = lon_b - 2.50;

rail_len = 28.00;
rail_h   =  6.00;
rail_w   =  3.30;

//Slot size
slot_bw = 69;
slot_tw = 64;

//ZIF
zif_w = 51.0;
zif_l = 23.0;
zif_inset = 2.00;

// Special Options
withZIFWindow = false;
withBottomText = false;

// --------------------------------------------------------
// Main build
// --------------------------------------------------------

topPart();
translate([-lar_t-10,0,0]) bottomPart();

// --------------------------------------------------------
// Modules and sub-parts
// --------------------------------------------------------

module topPart() {
    difference() {
        topMod();
        if (withZIFWindow) {
            translate([lar_t/2,((lon_t-pcbf_y)/2)+pcbf_y+6.5,-0.1])
                cube(size=[51,23,haut*3], center=true);
        }
    }
}

module bottomPart() {
    difference() {
        bottomMod();
        if (withBottomText) {
            translate([(lar_t/2),(lon_t*0.6),-0.1]) 
                linear_extrude(height=0.3) {
                    rotate(a=[0,180,0])
                        text("VECTREX", 
                            size = 10, 
                            font = "Stencil",
                            halign = "center",
                            valign = "center",
                            $fn = 16);
                }
        }
    }
}

module bottomMod() {

    // Main body

    difference() {
        difference() {
            bottomShell();
            // Grip pattern
            union() {
                translate([0,grip_y1,0]) grip();
                translate([lar_t,grip_y1,0]) grip();
            }
        }
        //bottom slotspace
        bottomShell_slotbevel();
    }

    // PCB fence

    pcbBottomFence();

    // Side holders ("jointbits")

    halfw = jointbit_w/2;

    translate([jointbit_x1 + halfw, lon_t*0.7, 0]) sideLock();
    translate([jointbit_x4 - halfw, lon_t*0.7, 0]) sideLock();
    translate([lar_t/2, jointbit_y3 - halfw, 0]) rotate([0,0,90]) sideLock();

    // Pins

    difference() {
        translate([lar_t/2, y_pinsAB, 0]) pinA();
        translate([lar_t/2, y_pinsAB, 0]) pinAHole();
    }

    translate([x_pinB1, y_pinsAB, 0]) pinB();
    translate([x_pinB2, y_pinsAB, 0]) pinB();

    translate([x_pinC, y_pinC, 0]) pinC();
    translate([lar_t-x_pinC, y_pinC, 0]) pinC();

}

module topMod() {

    // Main body

    difference() {
        difference() {
            topShell();
            // Grip pattern
            union() {
                translate([0,grip_y1,0]) grip();
                translate([lar_t,grip_y1,0]) grip();
            }
        }
        //bottom slotspace
        topShell_slotbevel();
    }

    // PCB fence
    pcbTopFence();

    // Pins

    translate([x_pinD, y_pinsD, 0]) pinD();
    translate([lar_t-x_pinD, y_pinsD, 0]) pinD();

    translate([lar_t/2, y_pinE, 0]) pinE();

}

// --------------------------------------------------------
// Sub-parts
// --------------------------------------------------------

module grip() {
    barh = haut*2;
    barwy = grip_len / (grip_count*2);
    barwx = grip_size;
    
    for(i = [0 : grip_count-1])
        //translate([0,i*(barwy*2),haut/2])
            //cube(size=[barwx,barwy,barh], center=true);
        translate([0,i*(barwy*2),-0.1])
            cylinder(barh,barwx,barwx/4,$fn=4);
   
}

module sideLock() {

    //"jointbit"
    translate([0,0,jointbit_h/2])
    cube(size=[jointbit_w,jointbit_len,jointbit_h], center=true);
    
}

module pinA() {
    r1 = (a_diam1 * 1.2) / 2;
    r2 = (a_diam1) / 2;
    difference() {
        union() {
            cylinder(a_h1, r1, r2);
            cylinder(r=a_diam2/2, h=a_h2);
            cylinder(r=a_diam3/2, h=a_h3);
        }
        translate([0,0,-0.1]) cylinder(r=a_hole/2, h=a_h3+0.2);
    }
}

module pinAHole() {
    //bottom hole in the shell (complementary to pinA)
    //Conic = support not needed
    translate([0, 0, a_sh_inset/2]) 
        cylinder(a_sh_inset/2+0.2, a_sh_diam/2, a_sh_diam/3);
    translate([0, 0, -0.1]) 
        cylinder(r=a_sh_diam/2, h=a_sh_inset/2+0.2);
}

module pinB() {
    r1 = (b_diam1 * 1.2) / 2;
    r2 = (b_diam1) / 2;
    difference() {
        union() {
            cylinder(b_h1, r1, r2);
            cylinder(r=b_diam2/2, h=b_h2);
        }
        translate([0,0,-0.1]) cylinder(r=b_hole/2, h=b_h2+0.2);
    }
}

module pinC() {
   difference() {
       cylinder(r=c_diam/2, h=c_height);
       translate([0,0,-0.1]) cylinder(r=c_hole/2, h=c_height+0.2);
    }
    translate([-c_leg_ep/2,-(c_leg_w+c_hole),0]) cube(size=[c_leg_ep,c_leg_w,c_leg_h], center=false);
}

module pinD() {
    r1 = (d_diam * 1.2) / 2;
    r2 = (d_diam) / 2;
    difference() {
        difference() {
            cylinder(d_height, r1, r2);
            translate([0,0,-0.1]) cylinder(r=d_hole/2, h=d_height+0.2);
        }
        translate([0,0,-0.1]) cylinder(r=d_diam, h=ep/3);
    }
}

module pinE() {
    r1 = (e_diam * 1.35) / 2;
    r2 = (e_diam) / 2;
    difference() {
        union() {
            cylinder(e_height, r1, r2);
            translate([0,0,e_height/2]) cube(size=[e_barw,e_barep,e_height], center=true);
        }
        translate([0,0,-0.1]) union() {
            cylinder(r=e_hole/2, h=e_height+0.2);
            translate([0,0,e_height/2]) cube(size=[e_diam*0.65,0.3,e_height+0.4], center=true);
            translate([0,0,e_height/2]) rotate([0,0,60]) cube(size=[e_diam*0.65,0.3,e_height+0.4], center=true);
            translate([0,0,e_height/2]) rotate([0,0,120]) cube(size=[e_diam*0.65,0.3,e_height+0.4], center=true);
        }
    }
}

module pcbBottomFence() {

    fep = pcbf_ep;
    x1window = (lar_t - pcbf_ww) / 2;
    x2window = lar_t - x1window;
    xspace = ep+joint_w+0.1;
    
    difference() {
        union() {
        translate([ep,pcbf_y,0])
            cube(size=[lar_t-(ep*2), fep, joint_h-0.1], center=false);
        translate([xspace+0.2,pcbf_y,0])
            cube(size=[lar_t-(xspace*2)-0.4, fep, pcbf_fh], center=false);
        }
        translate([x1window,pcbf_y-0.1,pcbf_wh])
            cube(size=[pcbf_ww, fep+0.2, pcbf_fh], center=false);
    }
    
}

module pcbTopFence() {

    fep = pcbf_ep;
    x1window = (lar_t - pcbf_ww) / 2;
    x2window = lar_t - x1window;
    xspace = ep+joint_w+0.1;
    
    translate([lar_t/2,pcbf_y,pcb_top_level/2]) 
        cube(size=[lar_b-(rail_w*2.4), fep, pcb_top_level], center=true);
    
}

module bottomShell() {

    difference() {
        difference() {
            difference() {
                bottomShell_outside();
                bottomShell_inside();
            }
            shell_jointspace();
        }
        translate([lar_t/2, y_pinsAB, 0]) pinAHole();
    }
    
    //todo : holes for top shell lockers
    
}

module topShell() {
    
    xdiff = (lar_t - lar_b) / 2;
    
    difference() {
        union() {
            difference() {
                difference() {
                    topShell_outside();
                    topShell_inside();
                }
            }
            translate([xdiff,0,0])
                cube(size=[rail_w+ep, rail_len+ep, rail_h+ep], center=false);
            translate([lar_b-(rail_w+ep),0,0])
                cube(size=[rail_w+ep, rail_len+ep, rail_h+ep], center=false);
        }
        union() {
            translate([-0.1,-0.1,-0.1])
                cube(size=[rail_w, rail_len, rail_h+0.3], center=false);
            translate([lar_t-rail_w,-0.1,-0.1])
                cube(size=[rail_w, rail_len, rail_h+0.3], center=false);
        }
    }

}


module bottomShell_outside() {
    
    xdiff = (lar_t - lar_b) / 2;
    x1 = xdiff;
    x2 = lar_t - xdiff;
    y1 = 0;
    y2 = lon_b;
    top = haut;
    
    ShellPoints = [
      [    x1,     y1,     0 ],  //0
      [    x2,     y1,     0 ],  //1
      [    x2,     y2,     0 ],  //2
      [    x1,     y2,     0 ],  //3
      [     0,      0,   top ],  //4
      [ lar_t,      0,   top ],  //5
      [ lar_t,  lon_t,   top ],  //6
      [     0,  lon_t,   top ]]; //7
    
    ShellFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
    
    polyhedron( ShellPoints, ShellFaces );
    
}

module bottomShell_slotbevel() {

    //bottom slotspace
    slotx = (lar_t-slot_bw)/2;
    translate([slotx,-0.1,ep])
        cube(size=[slot_bw, pcbf_y,haut], center=false);
    //slot bevel
    
    translate([lar_t/2,ep,haut/2+ep])
    hull() {
        rotate([90,0,0])
            linear_extrude(ep)
                square(size=[slot_bw,haut], center=true);
        translate([0,-ep*3,0])
            rotate([90,0,0])
                linear_extrude(ep)
                    square(size=[slot_bw+ep*2,haut+ep*2], center=true);
    }
}

module bottomShell_inside() {
    
    xdiff = (lar_t - lar_b) / 2;
    bx1 = ep + jointspace;
    bx2 = lar_t - (bx1);
    by1 = -0.5;
    by2 = lon_b - ep;
    top = haut + 0.1;
    tx1 = bx1;
    tx2 = bx2;
    ty1 = -0.1;
    ty2 = lon_b - ep;
    
    ShellPoints = [
      [ bx1, by1,  ep ],  //0
      [ bx2, by1,  ep ],  //1
      [ bx2, by2,  ep ],  //2
      [ bx1, by2,  ep ],  //3
      [ tx1, ty1, top ],  //4
      [ tx2, ty1, top ],  //5
      [ tx2, ty2, top ],  //6
      [ tx1, ty2, top ]]; //7
    
    ShellFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
    
    polyhedron( ShellPoints, ShellFaces );
    
}

module shell_jointspace() {
    
    cx = lar_t-(ep*2);
    cy = lon_t-(jointstarty+ep);
    cz = haut;
    
    translate([ep,jointstarty,joint_h])
    cube([cx,cy,cz]);
}

module topShell_outside() {
    
    xdiff = (lar_t - lar_b) / 2;
    x1 = xdiff;
    x2 = lar_t - xdiff;
    y1 = 0;
    y2 = lon_b;
    top = hautTop;
    
    ShellPoints = [
      [    x1,     y1,     0 ],  //0
      [    x2,     y1,     0 ],  //1
      [    x2,     y2,     0 ],  //2
      [    x1,     y2,     0 ],  //3
      [     0,      0,   top ],  //4
      [ lar_t,      0,   top ],  //5
      [ lar_t,  lon_t,   top ],  //6
      [     0,  lon_t,   top ]]; //7
    
    ShellFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
    
    polyhedron( ShellPoints, ShellFaces );
    
    loose = 0.40;
    
    translate([ep,jointstarty+loose])
    cube(size=[lar_t-(ep*2),lon_t-jointstarty-(ep)-(loose*2),hautTop+(haut-joint_h)-loose], centered=false);
}

module topShell_slotbevel() {

    //top slotspace
    slotx = (lar_t-slot_bw)/2;
    
    translate([slotx,-0.1,ep+rail_h-0.1])
        cube(size=[slot_bw, pcbf_y,haut], center=false);

    slotxt = (lar_t-slot_tw)/2;
    translate([slotxt,-0.1,ep])
        cube(size=[slot_tw, pcbf_y,haut], center=false);


    //slot bevel
    
    translate([lar_t/2,ep,haut/2+ep])
    hull() {
        rotate([90,0,0])
            linear_extrude(ep)
                square(size=[slot_tw,haut], center=true);
        translate([0,-ep*3,0])
            rotate([90,0,0])
                linear_extrude(ep)
                    square(size=[slot_tw+ep*2,haut+ep*2], center=true);
    }

    
    translate([lar_t/2,ep,haut/2+rail_h+ep])
    hull() {
        rotate([90,0,0])
            linear_extrude(ep)
                square(size=[slot_bw,haut], center=true);
        translate([0,-ep*3,0])
            rotate([90,0,0])
                linear_extrude(ep)
                    square(size=[slot_bw+ep*2,haut+ep*2], center=true);
    }

}


module topShell_inside() {
    
    xdiff = (lar_t - lar_b) / 2;
    bx1 = ep + jointspace;
    bx2 = lar_t - (bx1);
    by1 = -0.5;
    by2 = lon_b - ep;
    top = hautTop + 10.1;
    tx1 = bx1;
    tx2 = bx2;
    ty1 = -0.1;
    ty2 = lon_b - (ep + jointspace);
    
    ShellPoints = [
      [ bx1, by1,  ep ],  //0
      [ bx2, by1,  ep ],  //1
      [ bx2, by2,  ep ],  //2
      [ bx1, by2,  ep ],  //3
      [ tx1, ty1, top ],  //4
      [ tx2, ty1, top ],  //5
      [ tx2, ty2, top ],  //6
      [ tx1, ty2, top ]]; //7
    
    ShellFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
    
    polyhedron( ShellPoints, ShellFaces );
    
    // Line
    /*
    translate([lar_t/2,top_line_y,-0.1])
        cube(size=[lar_t-ep*2, top_line_ep, top_line_inset+0.1], center=true);
    */
    
    // Label
    /*
    translate([top_label_x1,top_label_y1,-0.1])
        cube(size=[top_label_x2-top_label_x1, top_label_y2-top_label_y1, top_line_inset+0.1], center=false);
    */

    //Arrow and text ?
    /*
    translate([(lar_t/2),(lon_t*0.30),-0.1]) 
        linear_extrude(height=0.3) {
            rotate(a=[180,0,0])
                text(   "INSERT TO THIS LINE",
                        size = 3,
                        font = "Arial", 
                        halign = "center", 
                        valign = "center", 
                        $fn = 16);
        }    
    */
}

