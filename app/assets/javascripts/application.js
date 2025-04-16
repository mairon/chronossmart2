//= require jquery
//= require jquery_ujs
//= require select2
//= require jquery.maskMoney
//= require abas
//= require ui/jquery.ui.core
//= require ui/jquery.ui.widget
//= require ui/jquery.ui.position
//= require ui/jquery.ui.menu
//= require ui/jquery.ui.menubar
//= require ui/jquery.ui.progressbar
//= require ui/jquery.ui.autocomplete

//= require multiselect/js/jquery.multi-select.min
//= require emulatetab.joelpurra
//= require plusastab.joelpurra
//= require validation/jquery.validate
//= require selectize/dist/js/standalone/selectize
//= require datepicker
//= require jquery.lineProgressbar
//= require all
//= require bootstrap-switch.min
//= require jquery.treegrid.min
//= require webcam.min
//= require bootstrap


// Make Dropdown Submenus possible
$( document ).ready(function() {
    $('[data-toggle="tooltip"]').tooltip();

   // Make Secondary Dropdown on Click
   $('.dropdown-submenu a.dropdown-submenu-toggle').on("click", function(e){
      $('.dropdown-submenu ul').removeAttr('style');
      $(this).next('ul').toggle();
      e.stopPropagation();
      e.preventDefault();
   });

   // Make Secondary Dropdown on Hover
   $('.dropdown-submenu a.dropdown-submenu-toggle').hover(function(){
      $('.dropdown-submenu ul').removeAttr('style');
      $(this).next('ul').toggle();
   });



});

	JoelPurra.PlusAsTab.setOptions({
		// Use enter instead of plus
		// Number 13 found through demo at
		// http://api.jquery.com/event.which/
		key: 13
	});

	$("form")
			.submit(simulateSubmitting);

function simulateSubmitting(event)
	{
		event.preventDefault();

		if (confirm("Simulating that the form has been submitted.\n\nWould you like to reload the page?"))
		{
			location.reload();
		}

		return false;
	}

$(document).ready(function() {
    $('.selectize').selectize();
	$('.pre-selected-options').multiSelect({cssClass:"full_width"});
		$(".money_us").maskMoney({thousands:".", decimal:","});
		$(".money_gs").maskMoney({thousands:".", decimal:",", precision:0, defaultZero: true});
		$(".money_ds").maskMoney({thousands:".", decimal:",", precision:4, defaultZero: true});
        $(".money_5").maskMoney({thousands:".", decimal:",", precision:5, defaultZero: true});
        $(".money_3").maskMoney({thousands:".", decimal:",", precision:3, defaultZero: true});
        $(".money_2").maskMoney({thousands:".", decimal:",", precision: 2, defaultZero: true});
		$(".select").select2();
		$(".selc_medium").select2();
		$(".selc_mini").select2();

        $( document ).on( 'focus', ':input', function(){
            $('#inicio, #final').attr( 'autocomplete', 'off' );
        });

});




	(function ($, window) {

    $.fn.contextMenu = function (settings) {

        return this.each(function () {

            // Open context menu
            $(this).on("contextmenu", function (e) {
                // return native menu if pressing control
                if (e.ctrlKey) return;

                //open menu
                var $menu = $(settings.menuSelector)
                    .data("invokedOn", $(e.target))
                    .show()
                    .css({
                        position: "absolute",
                        left: getMenuPosition(e.clientX, 'width', 'scrollLeft'),
                        top: getMenuPosition(e.clientY, 'height', 'scrollTop')
                    })
                    .off('click')
                    .on('click', 'a', function (e) {
                        $menu.hide();

                        var $invokedOn = $menu.data("invokedOn");
                        var $selectedMenu = $(e.target);

                        settings.menuSelected.call(this, $invokedOn, $selectedMenu);
                    });

                return false;
            });

            //make sure menu closes on any click
            $('body').click(function () {
                $(settings.menuSelector).hide();
            });
        });

        function getMenuPosition(mouse, direction, scrollDir) {
            var win = $(window)[direction](),
                scroll = $(window)[scrollDir](),
                menu = $(settings.menuSelector)[direction](),
                position = mouse + scroll;

            // opening menu would pass the side of the page
            if (mouse + menu > win && menu < mouse)
                position -= menu;

            return position;
        }

    };
})(jQuery, window);


