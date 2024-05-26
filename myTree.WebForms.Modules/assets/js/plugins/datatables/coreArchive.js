(function(a) {
    a(document).ready(function(b) {

        a('#checkall').click(function() {
            var oTable = $('#da-ex-datatable-todo').dataTable();
            var chk = this.checked;
            a('input[name="check"]').each(function() { a(this, oTable.fnGetNodes()).attr('checked', chk); })
        });

        a("table.data-table-action").dataTable({
            sPaginationType: "full_numbers",
            "bRetrieve": true,
            "iDisplayLength": 10,
//            "fnInfoCallback": function(oSettings, iStart, iEnd, iMax, iTotal, sPre) {
//                //var nCells = '<select><option>Select Action</option><option>Not started</option></select>';
//                //var nCells = a(".dropdown-action").html();
//                var nCells = a(this).parent().next(".dropdown-action").html();
//                //alert(nCells);
//                return nCells + sPre;
//            },
            "bFilter": false,
            "bLengthChange": false,
            "fnPreDrawCallback": function() {

                //a(this).html('loading...');
                return true;
            }

        });
        a("table.data-table").dataTable({
            sPaginationType: "full_numbers",
            "bRetrieve": true,
            "bDestroy": true,
            "iDisplayLength": 5,
            "bFilter": true,
            "bLengthChange": false
        });

        a("#user-info").click(function() {
            a(".header-dropdown").toggle();
        })
        a("body").bind("click", function(f) {
            a(".header-dropdown:visible").each(function() {
                if (!a(f.target).closest(a(this).parent()).length) {
                    a(this).hide()
                }
            })
        });
        a(".collapsible .da-panel-header").each(function() {
            if (a(this).find(".da-panel-toggler").size() === 0) {
                a("<span></span>").addClass("da-panel-toggler").appendTo(a(this))
            }
        });
        a("div.da-panel.collapsible .da-panel-header .da-panel-toggler").on("click", function(f) {
            parentToggled = false;
            a(this).closest(".da-panel").children(":not(.da-panel-header)").slideToggle("normal", function() {
                if (!parentToggled) {
                    a(this).closest(".da-panel").toggleClass("collapsed");
                    parentToggled = true
                }
            });
            f.preventDefault()
        });
        a(".da-header-dropdown").each(function() {
            var e = a(this).bind("click", function(f) {
                f.stopPropagation()
            });
            e.parent().bind("click", function(f) {
                e.toggle()
            })
        });
        a("body").bind("click", function(f) {
            a(".da-header-dropdown:visible").each(function() {
                if (!a(f.target).closest(a(this).parent()).length) {
                    a(this).hide()
                }
            })
        });
        a(".da-message").on("click", function(f) {
            a(this).animate({
                opacity: 0
            }, function() {
                a(this).slideUp("normal", function() {
                    a(this).css("opacity", "")
                })
            });
            f.preventDefault()
        });

        a(".da-header-button").bind("mousedown", function(f) {
            a(this).addClass("active")
        }).bind("mouseup", function(f) {
            a(this).removeClass("active")
        }).children(".da-header-dropdown").bind("mousedown", function(f) {
            f.stopPropagation()
        });
        if (a.fn.placeholder) {
            a("[placeholder]").placeholder()
        }
        a("table.da-table tbody tr:nth-child(2n)").addClass("even");
        a("table.da-table tbody tr:nth-child(2n+1)").addClass("odd");
        a("div#da-content #da-main-nav ul li a, div#da-content #da-main-nav ul li span").bind("click", function(f) {
            if (a(this).next("ul").size() !== 0) {
                a(this).next("ul").slideToggle("normal", function() {
                    a(this).toggleClass("closed")
                });
                f.preventDefault()
            }
        });
//        a("#da-ex-calendars").fullCalendar({
//            header: {
//                left: "title",
//                center: "",
//                right: "prev,next"
//            },
//            lazyFetching: true,
//            editable: false,
//            events: f
//        });
//        a("#da-ex-calendar-ui").fullCalendar({
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
        if (a.fn.tinyscrollbar) {
            a(".da-panel.scrollable .da-panel-content").each(function() {
                var e = a(this).height(), f = a(this).children().wrapAll('<div class="overview"></div>').end().children().wrapAll('<div class="viewport"></div>').end().find(".viewport").css("height", e).end().append('<div class="scrollbar"><div class="track"><div class="thumb"><div class="end"></div></div></div></div>').tinyscrollbar({
                    axis: "x"
                });
                a(window).resize(function() {
                    f.tinyscrollbar_update()
                })
            })
        }
        if (a.fn.tipsy) {
            var d = ["n", "ne", "e", "se", "s", "sw", "w", "nw"];
            for (var b in d) {
                a(".da-tooltip-" + d[b]).tipsy({
                    gravity: d[b]
                })
            }
            a("input[title], select[title], textarea[title]").tipsy({
                trigger: "focus",
                gravity: "w"
            })
        }
        if (a.fn.customFileInput) {
            a("input[type='file'].da-custom-file").customFileInput()
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
//        a("table.rmlist").dataTable({
//            sPaginationType: "full_numbers",
//            "bRetrieve": true,
//            "iDisplayLength": 2,
//            "fnInfoCallback": function(oSettings, iStart, iEnd, iMax, iTotal, sPre) {
//                //var nCells = '<select><option>Select Action</option><option>Not started</option></select>';
//                //var nCells = a(".dropdown-action").html();
//                var nCells = a(this).parent().next(".dropdown-action").html();
//                //alert(nCells);
//                return nCells + sPre;
//            },
//            "aaSorting": [[0, "desc"]],
//            "aoColumns": [{"bVisible": false},null,null,null,null,null,null,null],
//            "bFilter": false,
//            "bLengthChange": false,
//            "fnPreDrawCallback": function() {

//                //a(this).html('loading...');
//                return true;
//            }

//        });
//        /* Created by FMohamad */


    })(jQuery);
 
