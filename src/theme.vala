/* -*- Mode: vala; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * Copyright (C) 2010-2013 Robert Ancell
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 2 of the License, or (at your option) any later
 * version. See http://www.gnu.org/copyleft/gpl.html the full text of the
 * license.
 */

private class Theme : Object
{
    /* Colors of tiles and text */
    private Cairo.Pattern tile_colors [10];
    private Cairo.Pattern paused_color;
    private Cairo.Pattern text_colors [10];

    /*\
    * * init colors arrays
    \*/

    construct
    {
        tile_colors [0] = make_color_pattern ("#000000");
        tile_colors [1] = make_color_pattern ("#C17D11");
        tile_colors [2] = make_color_pattern ("#CC0000");
        tile_colors [3] = make_color_pattern ("#F57900");
        tile_colors [4] = make_color_pattern ("#EDD400");
        tile_colors [5] = make_color_pattern ("#73D216");
        tile_colors [6] = make_color_pattern ("#3465A4");
        tile_colors [7] = make_color_pattern ("#75507B");
        tile_colors [8] = make_color_pattern ("#BABDB6");
        tile_colors [9] = make_color_pattern ("#FFFFFF");

        paused_color = make_color_pattern ("#CCCCCC");

        text_colors [0] = new Cairo.Pattern.rgb (1, 1, 1);
        text_colors [1] = new Cairo.Pattern.rgb (1, 1, 1);
        text_colors [2] = new Cairo.Pattern.rgb (1, 1, 1);
        text_colors [3] = new Cairo.Pattern.rgb (1, 1, 1);
        text_colors [4] = new Cairo.Pattern.rgb (0, 0, 0);
        text_colors [5] = new Cairo.Pattern.rgb (0, 0, 0);
        text_colors [6] = new Cairo.Pattern.rgb (1, 1, 1);
        text_colors [7] = new Cairo.Pattern.rgb (1, 1, 1);
        text_colors [8] = new Cairo.Pattern.rgb (0, 0, 0);
        text_colors [9] = new Cairo.Pattern.rgb (0, 0, 0);
    }

    private Cairo.Pattern make_color_pattern (string color)
    {
        double r = (hex_value (color [1]) * 16 + hex_value (color [2])) / 255.0;
        double g = (hex_value (color [3]) * 16 + hex_value (color [4])) / 255.0;
        double b = (hex_value (color [5]) * 16 + hex_value (color [6])) / 255.0;
        return new Cairo.Pattern.rgb (r, g, b);
    }

    private double hex_value (char c)
    {
        if (c >= '0' && c <= '9')
            return c - '0';
        else if (c >= 'a' && c <= 'f')
            return c - 'a' + 10;
        else if (c >= 'A' && c <= 'F')
            return c - 'A' + 10;
        else
            return 0;
    }

    /*\
    * * drawing arrow
    \*/

    private uint previous_arrow_size = 0;
    private double arrow_half_h;
    private double neg_arrow_half_h;
    private uint arrow_depth;
    private double arrow_dx;
    private double arrow_dy;
    private double neg_arrow_dy;

    private inline void set_arrow_variables (uint size)
    {
        arrow_half_h = size * 0.75;
        neg_arrow_half_h = -arrow_half_h;
        arrow_depth = uint.min ((uint) (size * 0.025), 2);
        arrow_dx = 1.4142 * arrow_depth;
        arrow_dy = arrow_half_h - 6.1623 * arrow_depth;
        neg_arrow_dy = -arrow_dy;
        previous_arrow_size = size;
    }

    internal void draw_arrow (Cairo.Context context, uint size, uint gap)  // TODO manage gap width in themes
    {
        if (previous_arrow_size == 0 || size != previous_arrow_size)
            set_arrow_variables (size);
        double arrow_w = gap * 0.5;
        double arrow_w_minus_depth = arrow_w - arrow_depth;

        /* Background */
        context.move_to (0, 0);
        context.line_to (arrow_w, arrow_half_h);
        context.line_to (arrow_w, neg_arrow_half_h);
        context.close_path ();
        context.set_source_rgba (0, 0, 0, 0.125);
        context.fill ();

        /* Arrow highlight */
        context.move_to (arrow_w, neg_arrow_half_h);
        context.line_to (arrow_w, arrow_half_h);
        context.line_to (arrow_w_minus_depth, arrow_dy);
        context.line_to (arrow_w_minus_depth, neg_arrow_dy);
        context.close_path ();
        context.set_source_rgba (1, 1, 1, 0.125);
        context.fill ();

        /* Arrow shadow */
        context.move_to (arrow_w, neg_arrow_half_h);
        context.line_to (0, 0);
        context.line_to (arrow_w, arrow_half_h);
        context.line_to (arrow_w_minus_depth, arrow_dy);
        context.line_to (arrow_dx, 0);
        context.line_to (arrow_w_minus_depth, neg_arrow_dy);
        context.close_path ();
        context.set_source_rgba (0, 0, 0, 0.25);
        context.fill ();
    }

    /*\
    * * drawing sockets
    \*/

    private uint previous_socket_size = 0;
    private uint socket_depth;
    private uint size_minus_socket_depth;
    private uint size_minus_two_socket_depths;

    private inline void set_socket_variables (uint size)
    {
        socket_depth = uint.min ((uint) (size * 0.05), 4);
        size_minus_socket_depth = size - socket_depth;
        size_minus_two_socket_depths = size - socket_depth * 2;
        previous_socket_size = size;
    }

    internal void draw_socket (Cairo.Context context, uint size)
    {
        if (previous_socket_size == 0 || previous_socket_size != size)
            set_socket_variables (size);

        /* Background */
        context.rectangle (socket_depth, socket_depth, size_minus_two_socket_depths, size_minus_two_socket_depths);
        context.set_source_rgba (0, 0, 0, 0.125);
        context.fill ();

        /* Shadow */
        context.move_to (size, 0);
        context.line_to (0, 0);
        context.line_to (0, size);
        context.line_to (socket_depth, size_minus_socket_depth);
        context.line_to (socket_depth, socket_depth);
        context.line_to (size_minus_socket_depth, socket_depth);
        context.close_path ();
        context.set_source_rgba (0, 0, 0, 0.25);
        context.fill ();

        /* Highlight */
        context.move_to (0, size);
        context.line_to (size, size);
        context.line_to (size, 0);
        context.line_to (size_minus_socket_depth, socket_depth);
        context.line_to (size_minus_socket_depth, size_minus_socket_depth);
        context.line_to (socket_depth, size_minus_socket_depth);
        context.close_path ();
        context.set_source_rgba (1, 1, 1, 0.125);
        context.fill ();
    }

    /*\
    * * drawing tiles
    \*/

    private uint previous_tile_size = 0;
    private uint tile_depth;
    private double tile_dx;
    private double tile_dy;
    private double size_minus_tile_depth;
    private double size_minus_tile_dx;
    private double half_tile_size;
    private double half_tile_size_minus_dy;
    private double half_tile_size_plus_dy;
    private double size_minus_one;

    private inline void set_tile_variables (uint size)
    {
        tile_depth = uint.min ((uint) (size * 0.05), 4);
        tile_dx = 2.4142 * tile_depth;
        tile_dy = 1.4142 * tile_depth;
        size_minus_tile_depth = (double) size - tile_depth;
        size_minus_tile_dx = (double) size - tile_dx;
        half_tile_size = size * 0.5;
        half_tile_size_minus_dy = half_tile_size - tile_dy;
        half_tile_size_plus_dy = half_tile_size + tile_dy;
        previous_tile_size = size;
        size_minus_one = (double) (size - 1);
    }

    internal void draw_paused_tile (Cairo.Context context, uint size)
    {
        draw_tile_background (context, size, paused_color, paused_color, paused_color, paused_color);
    }

    internal void draw_tile (Cairo.Context context, uint size, Tile tile)
    {
        draw_tile_background (context, size, tile_colors [tile.north], tile_colors [tile.east], tile_colors [tile.south], tile_colors [tile.west]);

        context.select_font_face ("Sans", Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
        context.set_font_size (size / 3.5);
        context.set_source (text_colors [tile.north]);
        draw_number (context, half_tile_size, size / 5, tile.north);
        context.set_source (text_colors [tile.south]);
        draw_number (context, half_tile_size, size * 4 / 5, tile.south);
        context.set_source (text_colors [tile.east]);
        draw_number (context, size * 4 / 5, half_tile_size, tile.east);
        context.set_source (text_colors [tile.west]);
        draw_number (context, size / 5, half_tile_size, tile.west);
    }

    private void draw_tile_background (Cairo.Context context, uint size, Cairo.Pattern north_color, Cairo.Pattern east_color, Cairo.Pattern south_color, Cairo.Pattern west_color)
    {
        if (previous_tile_size == 0 || previous_tile_size != size)
            set_tile_variables (size);

        /* North */
        context.rectangle (0, 0, size, half_tile_size);
        context.set_source (north_color);
        context.fill ();

        /* North highlight */
        context.move_to (0, 0);
        context.line_to (size, 0);
        context.line_to (size_minus_tile_dx, tile_depth);
        context.line_to (tile_dx, tile_depth);
        context.line_to (half_tile_size, half_tile_size_minus_dy);
        context.line_to (half_tile_size, half_tile_size);
        context.close_path ();
        context.set_source_rgba (1, 1, 1, 0.125);
        context.fill ();

        /* North shadow */
        context.move_to (size, 0);
        context.line_to (half_tile_size, half_tile_size);
        context.line_to (half_tile_size, half_tile_size_minus_dy);
        context.line_to (size_minus_tile_dx, tile_depth);
        context.close_path ();
        context.set_source_rgba (0, 0, 0, 0.25);
        context.fill ();

        /* South */
        context.rectangle (0, half_tile_size, size, half_tile_size);
        context.set_source (south_color);
        context.fill ();

        /* South highlight */
        context.move_to (0, size);
        context.line_to (tile_dx, size_minus_tile_depth);
        context.line_to (half_tile_size, half_tile_size_plus_dy);
        context.line_to (half_tile_size, half_tile_size);
        context.close_path ();
        context.set_source_rgba (1, 1, 1, 0.125);
        context.fill ();

        /* South shadow */
        context.move_to (0, size);
        context.line_to (size, size);
        context.line_to (half_tile_size, half_tile_size);
        context.line_to (half_tile_size, half_tile_size_plus_dy);
        context.line_to (size_minus_tile_dx, size_minus_tile_depth);
        context.line_to (tile_dx, size_minus_tile_depth);
        context.close_path ();
        context.set_source_rgba (0, 0, 0, 0.25);
        context.fill ();

        /* East */
        context.move_to (size, 0);
        context.line_to (size, size);
        context.line_to (half_tile_size, half_tile_size);
        context.close_path ();
        context.set_source (east_color);
        context.fill ();

        /* East highlight */
        context.move_to (size, 0);
        context.line_to (half_tile_size, half_tile_size);
        context.line_to (size, size);
        context.line_to (size_minus_tile_depth, size_minus_tile_dx);
        context.line_to (half_tile_size_plus_dy, half_tile_size);
        context.line_to (size_minus_tile_depth, tile_dx);
        context.close_path ();
        context.set_source_rgba (1, 1, 1, 0.125);
        context.fill ();

        /* East shadow */
        context.move_to (size, 0);
        context.line_to (size, size);
        context.line_to (size_minus_tile_depth, size_minus_tile_dx);
        context.line_to (size_minus_tile_depth, tile_dx);
        context.close_path ();
        context.set_source_rgba (0, 0, 0, 0.25);
        context.fill ();

        /* West */
        context.move_to (0, 0);
        context.line_to (0, size);
        context.line_to (half_tile_size, half_tile_size);
        context.close_path ();
        context.set_source (west_color);
        context.fill ();

        /* West highlight */
        context.move_to (0, 0);
        context.line_to (0, size);
        context.line_to (tile_depth, size_minus_tile_dx);
        context.line_to (tile_depth, tile_dx);
        context.close_path ();
        context.set_source_rgba (1, 1, 1, 0.125);
        context.fill ();

        /* West shadow */
        context.move_to (0, 0);
        context.line_to (half_tile_size, half_tile_size);
        context.line_to (0, size);
        context.line_to (tile_depth, size_minus_tile_dx);
        context.line_to (half_tile_size_minus_dy, half_tile_size);
        context.line_to (tile_depth, tile_dx);
        context.close_path ();
        context.set_source_rgba (0, 0, 0, 0.25);
        context.fill ();

        /* Draw outline */
        context.set_line_width (1.0);
        context.set_source_rgb (0.0, 0.0, 0.0);
        context.rectangle (0.5, 0.5, size_minus_one, size_minus_one);
        context.stroke ();
    }

    private void draw_number (Cairo.Context context, double x, double y, uint8 number)
    {
        string text = "%hu".printf (number);
        Cairo.TextExtents extents;
        context.text_extents (text, out extents);
        context.move_to (x - extents.width / 2.0, y + extents.height / 2.0);
        context.show_text (text);
    }
}
