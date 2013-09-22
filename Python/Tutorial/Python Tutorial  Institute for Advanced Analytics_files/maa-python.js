
//  Initialize jQuery detail accordions in the HTML

$( function() {
  var  accordion_list;			// List of detail accordion IDs
  var  i;				// Current accordion_list index

  accordion_list = [
    "#var-accordion", "#dict-accordion", "#loop-accordion",
    "#for-accordion", "#bug-accordion", "#seek-accordion",
    "#newline-accordion", "#max-pop-accordion", "#fib-accordion",
    "#pandas-pop-accordion", "#pandas-slice-accordion"
  ];

  for ( i in accordion_list ) {
    $( accordion_list[ i ] ).accordion( {
      active: false,
      collapsible: true,
      autoHeight: false,
      heightStyle: "content"
    } );
  }

  //  This code tracks the navigation bar, if it scrolls past the top
  //  of the page, it's "floated" and pinned to the top of the page

  var  is_fixed;			// Nav bar is pinned flag
  var  nav;				// Ref to nav bar's div
  var  nav_foot;			// Ref to nav bar's bottom spacer
  var  nav_y;				// Top of nav bar y-offset on page
  var  w;				// Reference to main window


  nav = $("#nav");			// Grab nav bar div, footer div
  nav_foot = $("#nav-footer");

  nav_y = nav.offset().top;		// Get nav bar's top offset on page

  is_fixed = false;

  w = $(window);
  w.scroll( function() {
    var  fixed;				// Nav bar should be fixed flag
    var  nav_h;				// Nav bar height
    var  top;				// Vert scrollbar's top offset on page

    top = w.scrollTop();		// Get vert sbar pos from top of page
    fixed = top > nav_y;		// Scrolled past nav bar's top on page?
    nav_h = $("#nav").height();		// Get nav bar's height

    if ( fixed && !is_fixed ) {		// Fix navbar in place?
      nav.css( {
        position: "fixed",
        top: 0,
        left: nav.offset().left,
        width: "98.5%"
      } );
      nav_foot.css( {
        position: "fixed",
        top: nav_h,
        left: nav.offset().left,
        width: "98.5%"
      } );

      is_fixed = true;

    } else if ( !fixed && is_fixed ) {	// Release fixed navbar?
      nav.css( {
        position: "static",
        width: "100%"
      } );
      nav_foot.css( {
        position: "static",
        width: "100%"
      } );

      is_fixed = false;
    }
  } );

  $("#nav-list li").click( function() {
    var  div_id	= [			// ID of div to scroll to
      { "id": "nav-intro", "div": "#intro" },
      { "id": "nav-var", "div": "#var" },
      { "id": "nav-datatype", "div": "#datatype" },
      { "id": "nav-cond", "div": "#cond" },
      { "id": "nav-op", "div": "#op" },
      { "id": "nav-file", "div": "#file" },
      { "id": "nav-func", "div": "#func" },
      { "id": "nav-numpy", "div": "#numpy" },
      { "id": "nav-pandas", "div": "#pandas" },
      { "id": "nav-web", "div": "#web" }
    ];
    var  i;				// Loop counter


    //  Find div ID for whatever nav item user clicked

    for( i = 0; i < div_id.length; i++ ) {
      if ( $(this).attr( "id" ) == div_id[ i ][ "id" ] ) {
        break;
      }
    }

    if ( i >= div_id.length ) {		// Unknown nav item?
      console.log( "Unknown navigation ID " + $(this).attr( "id" ) );
    } else {

    //  Animate the top of the div to the top of the page, but offset
    //  by 25px to account for the navigation toolbar itself

      $("html, body").animate(
        { scrollTop: $(div_id[ i ][ "div" ]).position().top - 25 }, 'swing' );
    }
  } );
} );
