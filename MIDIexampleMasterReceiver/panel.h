#ifndef PANEL_H
#define PANEL_H

struct panel {
    int addr;
    int toggle_delay;
    double sensitvity;
    int data[12];
    int ambient[12];
    int keyval[12];
    boolean pintog[12];
    boolean lastval;
};

#endif
