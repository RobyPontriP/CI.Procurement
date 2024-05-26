(function($) {
    $(document).ready(function(b) {

        $('#checkall').click(function() {
            var oTable = $('#da-ex-datatable-todo').dataTable();
            var chk = this.checked;
            $('input[name="check"]').each(function() { $(this, oTable.fnGetNodes()).attr('checked', chk); })
        });

        $("table.data-table-action").dataTable({
            sPaginationType: "full_numbers",
            "bRetrieve": true,
            "iDisplayLength": 10,
            "fnInfoCallback": function(oSettings, iStart, iEnd, iMax, iTotal, sPre) {
                //var nCells = '<select><option>Select Action</option><option>Not started</option></select>';
                //var nCells = $(".dropdown-action").html();
                var nCells = $(this).parent().next(".dropdown-action").html();
                //alert(nCells);
                return nCells + sPre;
            },
            "bFilter": true,
            "bLengthChange": false,
            "fnPreDrawCallback": function() {

                //$(this).html('loading...');
                return true;
            }

        });
        $("table.data-table").dataTable({
            sPaginationType: "full_numbers",
            "bRetrieve": true,
            "bDestroy": true,
            "iDisplayLength": 3,
            "bFilter": true,
            "bLengthChange": false
        });

        $("#user-info").click(function() {
            $(".header-dropdown").toggle();
        })
        $("body").bind("click", function(f) {
            $(".header-dropdown:visible").each(function() {
                if (!$(f.target).closest($(this).parent()).length) {
                    $(this).hide()
                }
            })
        });
        $(".collapsible .da-panel-header").each(function() {
            if ($(this).find(".da-panel-toggler").size() === 0) {
                $("<span></span>").addClass("da-panel-toggler").appendTo($(this))
            }
        });
        $("div.da-panel.collapsible .da-panel-header .da-panel-toggler").on("click", function(f) {
            parentToggled = false;
            $(this).closest(".da-panel").children(":not(.da-panel-header)").slideToggle("normal", function() {
                if (!parentToggled) {
                    $(this).closest(".da-panel").toggleClass("collapsed");
                    parentToggled = true
                }
            });
            f.preventDefault()
        });
        $(".da-header-dropdown").each(function() {
            var e = $(this).bind("click", function(f) {
                f.stopPropagation()
            });
            e.parent().bind("click", function(f) {
                e.toggle()
            })
        });
        $("body").bind("click", function(f) {
            $(".da-header-dropdown:visible").each(function() {
                if (!$(f.target).closest($(this).parent()).length) {
                    $(this).hide()
                }
            })
        });
        $(".da-message").on("click", function(f) {
            $(this).animate({
                opacity: 0
            }, function() {
                $(this).slideUp("normal", function() {
                    $(this).css("opacity", "")
                })
            });
            f.preventDefault()
        });

        $(".da-header-button").bind("mousedown", function(f) {
            $(this).addClass("active")
        }).bind("mouseup", function(f) {
            $(this).removeClass("active")
        }).children(".da-header-dropdown").bind("mousedown", function(f) {
            f.stopPropagation()
        });
        if ($.fn.placeholder) {
            $("[placeholder]").placeholder()
        }
        $("table.da-table tbody tr:nth-child(2n)").addClass("even");
        $("table.da-table tbody tr:nth-child(2n+1)").addClass("odd");
        $("div#da-content #da-main-nav ul li a, div#da-content #da-main-nav ul li span").bind("click", function(f) {
            if ($(this).next("ul").size() !== 0) {
                $(this).next("ul").slideToggle("normal", function() {
                    $(this).toggleClass("closed")
                });
                f.preventDefault()
            }
        });
//        $("#da-ex-calendars").fullCalendar({
//            header: {
//                left: "title",
//                center: "",
//                right: "prev,next"
//            },
//            lazyFetching: true,
//            editable: false,
//            events: f
//        });
//        $("#da-ex-calendar-ui").fullCalendar({
//            theme: true,
//            header: {
//                left: "prev,next today",
//                center: "title",
//                right: "month,agendaWeek,agendaDay"
//            },
//            //added by NAlfajri
//            eventClick: function(event) {
//                if (event.url) {
//                    $.fancybox({
//                        'href': event.url + '?title=' + encodeURIComponent(event.title) + '&date=' + encodeURIComponent(event.start) + '&desc=' + encodeURIComponent(event.description),
//                        'type': 'ajax',
//                        'autoSize': false,
//                        'width': 450,
//                        'height': 'auto',
//                        'autoHeight': true,
//                        'scrolling': 'no',
//                        'minHeight': 300
//                    });
//                    return false;
//                }
//            },
//            eventRender: function(event, element) {
//                qtipContent = '<div><h3>' + event.title + '</h3>';
//                qtipContent = qtipContent + '<span class="qtipDesc">' + event.description + '</span><span class="qtipMore" style="display:block;font-size:10px;">click events to read more</span></div>';
//                if (!isEmpty(event)) {
//                    element.qtip({
//                        content: '<span class="qtipDesc">' + event.description + '</span><span class="qtipMore" style="display:block;font-size:10px;"</span></div>', //qtipContent,
//                        style: {
//                            border: {
//                                width: 3,
//                                radius: 8,
//                                color: '#335308'
//                            },
//                            width: 200
//                        },
//                        position: {
//                            corner: {
//                                target: 'center',
//                                tooltip: 'bottomRight'
//                            },
//                            adjust: {
//                                y: -20,
//                                x: 100
//                            }
//                        }
//                    })
//                }
//                for (var i in dateArr) {
//                    if (event.end == null) { event.end = event.start; }

//                    if (dateArr[i].getDate() == event.start.getDate() && dateArr[i].getMonth() == event.start.getMonth()) {

//                        $('.fc-day' + i).css('background', '#FFCCCC');
//                        $('.fc-event-title').hide();
//                    }
//                }
//            },
//            editable: false,
//            events: 'CalendarRM.aspx'
//        });
        if ($.fn.tinyscrollbar) {
            $(".da-panel.scrollable .da-panel-content").each(function() {
                var e = $(this).height(), f = $(this).children().wrapAll('<div class="overview"></div>').end().children().wrapAll('<div class="viewport"></div>').end().find(".viewport").css("height", e).end().append('<div class="scrollbar"><div class="track"><div class="thumb"><div class="end"></div></div></div></div>').tinyscrollbar({
                    axis: "x"
                });
                $(window).resize(function() {
                    f.tinyscrollbar_update()
                })
            })
        }
        if ($.fn.tipsy) {
            var d = ["n", "ne", "e", "se", "s", "sw", "w", "nw"];
            for (var b in d) {
                $(".da-tooltip-" + d[b]).tipsy({
                    gravity: d[b]
                })
            }
            $("input[title], select[title], textarea[title]").tipsy({
                trigger: "focus",
                gravity: "w"
            })
        }
        if ($.fn.customFileInput) {
            $("input[type='file'].da-custom-file").customFileInput()
        }
        //calendar
        var c = new Date();
        var h = c.getDate();
        var b = c.getMonth();
        var i = c.getFullYear();
        var f = [{
            title: "All Day Event",
            start: new Date(i, b, 1)
        }, {
            title: "Meeting",
            start: new Date(i, b, h, 10, 30),
            allDay: false
        }, {
            title: "Lunch",
            start: new Date(i, b, h, 12, 0),
            end: new Date(i, b, h, 14, 0),
            allDay: false
        }, {
            title: "Birthday Party",
            start: new Date(i, b, h + 1, 19, 0),
            end: new Date(i, b, h + 1, 22, 30),
            allDay: false
        }, {
            title: "Click for Google",
            start: new Date(i, b, 28),
            end: new Date(i, b, 29),
            url: "http://google.com/"
}];


        })

//        /* Created by FMohamad */
//        $("table.rmlist").dataTable({
//            sPaginationType: "full_numbers",
//            "bRetrieve": true,
//            "iDisplayLength": 2,
//            "fnInfoCallback": function(oSettings, iStart, iEnd, iMax, iTotal, sPre) {
//                //var nCells = '<select><option>Select Action</option><option>Not started</option></select>';
//                //var nCells = $(".dropdown-action").html();
//                var nCells = $(this).parent().next(".dropdown-action").html();
//                //alert(nCells);
//                return nCells + sPre;
//            },
//            "aaSorting": [[0, "desc"]],
//            "aoColumns": [{"bVisible": false},null,null,null,null,null,null,null],
//            "bFilter": false,
//            "bLengthChange": false,
//            "fnPreDrawCallback": function() {

//                //$(this).html('loading...');
//                return true;
//            }

//        });
//        /* Created by FMohamad */


    })(jQuery);
 
