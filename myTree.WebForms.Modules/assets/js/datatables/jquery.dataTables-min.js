!function(a, b, c) {
    var d = function(d) {
        function e(a) {
            var b, c, f = {};
            d.each(a, function(d) {
                if ((b = d.match(/^([^A-Z]+?)([A-Z])/)) && -1 !== "a aa ai ao as b fn i m o s ".indexOf(b[1] + " ")) c = d.replace(b[0], b[2].toLowerCase()), 
                f[c] = d, "o" === b[1] && e(a[d]);
            });
            a._hungarianMap = f;
        }
        function f(a, b, g) {
            a._hungarianMap || e(a);
            var h;
            d.each(b, function(e) {
                h = a._hungarianMap[e];
                if (h !== c && (g || b[h] === c)) "o" === h.charAt(0) ? (b[h] || (b[h] = {}), d.extend(!0, b[h], b[e]), 
                f(a[h], b[h], g)) : b[h] = b[e];
            });
        }
        function g(a) {
            var b = Ub.defaults.oLanguage, c = a.sZeroRecords;
            !a.sEmptyTable && c && "No data available in table" === b.sEmptyTable && Jb(a, a, "sZeroRecords", "sEmptyTable");
            !a.sLoadingRecords && c && "Loading..." === b.sLoadingRecords && Jb(a, a, "sZeroRecords", "sLoadingRecords");
            a.sInfoThousands && (a.sThousands = a.sInfoThousands);
            (a = a.sDecimal) && Sb(a);
        }
        function h(a) {
            nc(a, "ordering", "bSort");
            nc(a, "orderMulti", "bSortMulti");
            nc(a, "orderClasses", "bSortClasses");
            nc(a, "orderCellsTop", "bSortCellsTop");
            nc(a, "order", "aaSorting");
            nc(a, "orderFixed", "aaSortingFixed");
            nc(a, "paging", "bPaginate");
            nc(a, "pagingType", "sPaginationType");
            nc(a, "pageLength", "iDisplayLength");
            nc(a, "searching", "bFilter");
            if (a = a.aoSearchCols) for (var b = 0, c = a.length; b < c; b++) a[b] && f(Ub.models.oSearch, a[b]);
        }
        function i(a) {
            nc(a, "orderable", "bSortable");
            nc(a, "orderData", "aDataSort");
            nc(a, "orderSequence", "asSorting");
            nc(a, "orderDataType", "sortDataType");
        }
        function j(a) {
            var a = a.oBrowser, b = d("<div/>").css({
                position: "absolute",
                top: 0,
                left: 0,
                height: 1,
                width: 1,
                overflow: "hidden"
            }).append(d("<div/>").css({
                position: "absolute",
                top: 1,
                left: 1,
                width: 100,
                overflow: "scroll"
            }).append(d('<div class="test"/>').css({
                width: "100%",
                height: 10
            }))).appendTo("body"), c = b.find(".test");
            a.bScrollOversize = 100 === c[0].offsetWidth;
            a.bScrollbarLeft = 1 !== c.offset().left;
            b.remove();
        }
        function k(a, b, d, e, f, g) {
            var h, i = !1;
            d !== c && (h = d, i = !0);
            for (;e !== f; ) a.hasOwnProperty(e) && (h = i ? b(h, a[e], e, a) : a[e], i = !0, 
            e += g);
            return h;
        }
        function l(a, c) {
            var e = Ub.defaults.column, f = a.aoColumns.length, e = d.extend({}, Ub.models.oColumn, e, {
                nTh: c ? c : b.createElement("th"),
                sTitle: e.sTitle ? e.sTitle : c ? c.innerHTML : "",
                aDataSort: e.aDataSort ? e.aDataSort : [ f ],
                mData: e.mData ? e.mData : f,
                idx: f
            });
            a.aoColumns.push(e);
            e = a.aoPreSearchCols;
            e[f] = d.extend({}, Ub.models.oSearch, e[f]);
            m(a, f, null);
        }
        function m(a, b, e) {
            var b = a.aoColumns[b], g = a.oClasses, h = d(b.nTh);
            if (!b.sWidthOrig) {
                b.sWidthOrig = h.attr("width") || null;
                var j = (h.attr("style") || "").match(/width:\s*(\d+[pxem%]+)/);
                j && (b.sWidthOrig = j[1]);
            }
            e !== c && null !== e && (i(e), f(Ub.defaults.column, e), e.mDataProp !== c && !e.mData && (e.mData = e.mDataProp), 
            e.sType && (b._sManualType = e.sType), e.className && !e.sClass && (e.sClass = e.className), 
            d.extend(b, e), Jb(b, e, "sWidth", "sWidthOrig"), "number" === typeof e.iDataSort && (b.aDataSort = [ e.iDataSort ]), 
            Jb(b, e, "aDataSort"));
            var k = b.mData, l = z(k), m = b.mRender ? z(b.mRender) : null, e = function(a) {
                return "string" === typeof a && -1 !== a.indexOf("@");
            };
            b._bAttrSrc = d.isPlainObject(k) && (e(k.sort) || e(k.type) || e(k.filter));
            b.fnGetData = function(a, b, d) {
                var e = l(a, b, c, d);
                return m && b ? m(e, b, a, d) : e;
            };
            b.fnSetData = function(a, b, c) {
                return A(k)(a, b, c);
            };
            a.oFeatures.bSort || (b.bSortable = !1, h.addClass(g.sSortableNone));
            a = -1 !== d.inArray("asc", b.asSorting);
            e = -1 !== d.inArray("desc", b.asSorting);
            !b.bSortable || !a && !e ? (b.sSortingClass = g.sSortableNone, b.sSortingClassJUI = "") : a && !e ? (b.sSortingClass = g.sSortableAsc, 
            b.sSortingClassJUI = g.sSortJUIAscAllowed) : !a && e ? (b.sSortingClass = g.sSortableDesc, 
            b.sSortingClassJUI = g.sSortJUIDescAllowed) : (b.sSortingClass = g.sSortable, b.sSortingClassJUI = g.sSortJUI);
        }
        function n(a) {
            if (!1 !== a.oFeatures.bAutoWidth) {
                var b = a.aoColumns;
                qb(a);
                for (var c = 0, d = b.length; c < d; c++) b[c].nTh.style.width = b[c].sWidth;
            }
            b = a.oScroll;
            ("" !== b.sY || "" !== b.sX) && ob(a);
            Nb(a, null, "column-sizing", [ a ]);
        }
        function o(a, b) {
            var c = r(a, "bVisible");
            return "number" === typeof c[b] ? c[b] : null;
        }
        function p(a, b) {
            var c = r(a, "bVisible"), c = d.inArray(b, c);
            return -1 !== c ? c : null;
        }
        function q(a) {
            return r(a, "bVisible").length;
        }
        function r(a, b) {
            var c = [];
            d.map(a.aoColumns, function(a, d) {
                a[b] && c.push(d);
            });
            return c;
        }
        function s(a) {
            var b = a.aoColumns, d = a.aoData, e = Ub.ext.type.detect, f, g, h, i, j, k, l, m, n;
            f = 0;
            for (g = b.length; f < g; f++) if (l = b[f], n = [], !l.sType && l._sManualType) l.sType = l._sManualType; else if (!l.sType) {
                h = 0;
                for (i = e.length; h < i; h++) {
                    j = 0;
                    for (k = d.length; j < k && !(n[j] === c && (n[j] = w(a, j, f, "type")), m = e[h](n[j], a), 
                    !m || "html" === m); j++) ;
                    if (m) {
                        l.sType = m;
                        break;
                    }
                }
                l.sType || (l.sType = "string");
            }
        }
        function t(a, b, e, f) {
            var g, h, i, j, k, m, n = a.aoColumns;
            if (b) for (g = b.length - 1; 0 <= g; g--) {
                m = b[g];
                var o = m.targets !== c ? m.targets : m.aTargets;
                d.isArray(o) || (o = [ o ]);
                h = 0;
                for (i = o.length; h < i; h++) if ("number" === typeof o[h] && 0 <= o[h]) {
                    for (;n.length <= o[h]; ) l(a);
                    f(o[h], m);
                } else if ("number" === typeof o[h] && 0 > o[h]) f(n.length + o[h], m); else if ("string" === typeof o[h]) {
                    j = 0;
                    for (k = n.length; j < k; j++) ("_all" == o[h] || d(n[j].nTh).hasClass(o[h])) && f(j, m);
                }
            }
            if (e) {
                g = 0;
                for (a = e.length; g < a; g++) f(g, e[g]);
            }
        }
        function u(a, b, c, e) {
            var f = a.aoData.length, g = d.extend(!0, {}, Ub.models.oRow, {
                src: c ? "dom" : "data"
            });
            g._aData = b;
            a.aoData.push(g);
            for (var b = a.aoColumns, g = 0, h = b.length; g < h; g++) c && x(a, f, g, w(a, f, g)), 
            b[g].sType = null;
            a.aiDisplayMaster.push(f);
            (c || !a.oFeatures.bDeferRender) && G(a, f, c, e);
            return f;
        }
        function v(a, b) {
            var c;
            b instanceof d || (b = d(b));
            return b.map(function(b, d) {
                c = F(a, d);
                return u(a, c.data, d, c.cells);
            });
        }
        function w(a, b, d, e) {
            var f = a.iDraw, g = a.aoColumns[d], h = a.aoData[b]._aData, i = g.sDefaultContent, d = g.fnGetData(h, e, {
                settings: a,
                row: b,
                col: d
            });
            if (d === c) return a.iDrawError != f && null === i && (Ib(a, 0, "Requested unknown parameter " + ("function" == typeof g.mData ? "{function}" : "'" + g.mData + "'") + " for row " + b, 4), 
            a.iDrawError = f), i;
            if ((d === h || null === d) && null !== i) d = i; else if ("function" === typeof d) return d.call(h);
            return null === d && "display" == e ? "" : d;
        }
        function x(a, b, c, d) {
            a.aoColumns[c].fnSetData(a.aoData[b]._aData, d, {
                settings: a,
                row: b,
                col: c
            });
        }
        function y(a) {
            return d.map(a.match(/(\\.|[^\.])+/g), function(a) {
                return a.replace(/\\./g, ".");
            });
        }
        function z(a) {
            if (d.isPlainObject(a)) {
                var b = {};
                d.each(a, function(a, c) {
                    c && (b[a] = z(c));
                });
                return function(a, d, e, f) {
                    var g = b[d] || b._;
                    return g !== c ? g(a, d, e, f) : a;
                };
            }
            if (null === a) return function(a) {
                return a;
            };
            if ("function" === typeof a) return function(b, c, d, e) {
                return a(b, c, d, e);
            };
            if ("string" === typeof a && (-1 !== a.indexOf(".") || -1 !== a.indexOf("[") || -1 !== a.indexOf("("))) {
                var e = function(a, b, d) {
                    var f, g;
                    if ("" !== d) {
                        g = y(d);
                        for (var h = 0, i = g.length; h < i; h++) {
                            d = g[h].match(oc);
                            f = g[h].match(pc);
                            if (d) {
                                g[h] = g[h].replace(oc, "");
                                "" !== g[h] && (a = a[g[h]]);
                                f = [];
                                g.splice(0, h + 1);
                                g = g.join(".");
                                h = 0;
                                for (i = a.length; h < i; h++) f.push(e(a[h], b, g));
                                a = d[0].substring(1, d[0].length - 1);
                                a = "" === a ? f : f.join(a);
                                break;
                            } else if (f) {
                                g[h] = g[h].replace(pc, "");
                                a = a[g[h]]();
                                continue;
                            }
                            if (null === a || a[g[h]] === c) return c;
                            a = a[g[h]];
                        }
                    }
                    return a;
                };
                return function(b, c) {
                    return e(b, c, a);
                };
            }
            return function(b) {
                return b[a];
            };
        }
        function A(a) {
            if (d.isPlainObject(a)) return A(a._);
            if (null === a) return function() {};
            if ("function" === typeof a) return function(b, c, d) {
                a(b, "set", c, d);
            };
            if ("string" === typeof a && (-1 !== a.indexOf(".") || -1 !== a.indexOf("[") || -1 !== a.indexOf("("))) {
                var b = function(a, d, e) {
                    var e = y(e), f;
                    f = e[e.length - 1];
                    for (var g, h, i = 0, j = e.length - 1; i < j; i++) {
                        g = e[i].match(oc);
                        h = e[i].match(pc);
                        if (g) {
                            e[i] = e[i].replace(oc, "");
                            a[e[i]] = [];
                            f = e.slice();
                            f.splice(0, i + 1);
                            g = f.join(".");
                            h = 0;
                            for (j = d.length; h < j; h++) f = {}, b(f, d[h], g), a[e[i]].push(f);
                            return;
                        }
                        h && (e[i] = e[i].replace(pc, ""), a = a[e[i]](d));
                        if (null === a[e[i]] || a[e[i]] === c) a[e[i]] = {};
                        a = a[e[i]];
                    }
                    if (f.match(pc)) a[f.replace(pc, "")](d); else a[f.replace(oc, "")] = d;
                };
                return function(c, d) {
                    return b(c, d, a);
                };
            }
            return function(b, c) {
                b[a] = c;
            };
        }
        function B(a) {
            return jc(a.aoData, "_aData");
        }
        function C(a) {
            a.aoData.length = 0;
            a.aiDisplayMaster.length = 0;
            a.aiDisplay.length = 0;
        }
        function D(a, b, d) {
            for (var e = -1, f = 0, g = a.length; f < g; f++) a[f] == b ? e = f : a[f] > b && a[f]--;
            -1 != e && d === c && a.splice(e, 1);
        }
        function E(a, b, d, e) {
            var f = a.aoData[b], g;
            if ("dom" === d || (!d || "auto" === d) && "dom" === f.src) f._aData = F(a, f).data; else {
                var h = f.anCells, i;
                if (h) {
                    d = 0;
                    for (g = h.length; d < g; d++) {
                        for (i = h[d]; i.childNodes.length; ) i.removeChild(i.firstChild);
                        h[d].innerHTML = w(a, b, d, "display");
                    }
                }
            }
            f._aSortData = null;
            f._aFilterData = null;
            a = a.aoColumns;
            if (e !== c) a[e].sType = null; else {
                d = 0;
                for (g = a.length; d < g; d++) a[d].sType = null;
            }
            H(f);
        }
        function F(a, b) {
            var c = [], e = [], f = b.firstChild, g, h, i, j = 0, k, l = a.aoColumns, m = function(a, b, c) {
                "string" === typeof a && (b = a.indexOf("@"), -1 !== b && (a = a.substring(b + 1), 
                i["@" + a] = c.getAttribute(a)));
            }, n = function(a) {
                h = l[j];
                k = d.trim(a.innerHTML);
                h && h._bAttrSrc ? (i = {
                    display: k
                }, m(h.mData.sort, i, a), m(h.mData.type, i, a), m(h.mData.filter, i, a), c.push(i)) : c.push(k);
                j++;
            };
            if (f) for (;f; ) {
                g = f.nodeName.toUpperCase();
                if ("TD" == g || "TH" == g) n(f), e.push(f);
                f = f.nextSibling;
            } else {
                e = b.anCells;
                f = 0;
                for (g = e.length; f < g; f++) n(e[f]);
            }
            return {
                data: c,
                cells: e
            };
        }
        function G(a, c, d, e) {
            var f = a.aoData[c], g = f._aData, h = [], i, j, k, l, m;
            if (null === f.nTr) {
                i = d || b.createElement("tr");
                f.nTr = i;
                f.anCells = h;
                i._DT_RowIndex = c;
                H(f);
                l = 0;
                for (m = a.aoColumns.length; l < m; l++) {
                    k = a.aoColumns[l];
                    j = d ? e[l] : b.createElement(k.sCellType);
                    h.push(j);
                    if (!d || k.mRender || k.mData !== l) j.innerHTML = w(a, c, l, "display");
                    k.sClass && (j.className += " " + k.sClass);
                    k.bVisible && !d ? i.appendChild(j) : !k.bVisible && d && j.parentNode.removeChild(j);
                    k.fnCreatedCell && k.fnCreatedCell.call(a.oInstance, j, w(a, c, l), g, c, l);
                }
                Nb(a, "aoRowCreatedCallback", null, [ i, g, c ]);
            }
            f.nTr.setAttribute("role", "row");
        }
        function H(a) {
            var b = a.nTr, c = a._aData;
            if (b) {
                c.DT_RowId && (b.id = c.DT_RowId);
                if (c.DT_RowClass) {
                    var e = c.DT_RowClass.split(" ");
                    a.__rowc = a.__rowc ? mc(a.__rowc.concat(e)) : e;
                    d(b).removeClass(a.__rowc.join(" ")).addClass(c.DT_RowClass);
                }
                c.DT_RowData && d(b).data(c.DT_RowData);
            }
        }
        function I(a) {
            var b, c, e, f, g, h = a.nTHead, i = a.nTFoot, j = 0 === d("th, td", h).length, k = a.oClasses, l = a.aoColumns;
            j && (f = d("<tr/>").appendTo(h));
            b = 0;
            for (c = l.length; b < c; b++) g = l[b], e = d(g.nTh).addClass(g.sClass), j && e.appendTo(f), 
            a.oFeatures.bSort && (e.addClass(g.sSortingClass), !1 !== g.bSortable && (e.attr("tabindex", a.iTabIndex).attr("aria-controls", a.sTableId), 
            Cb(a, g.nTh, b))), g.sTitle != e.html() && e.html(g.sTitle), Pb(a, "header")(a, e, g, k);
            j && N(a.aoHeader, h);
            d(h).find(">tr").attr("role", "row");
            d(h).find(">tr>th, >tr>td").addClass(k.sHeaderTH);
            d(i).find(">tr>th, >tr>td").addClass(k.sFooterTH);
            if (null !== i) {
                a = a.aoFooter[0];
                b = 0;
                for (c = a.length; b < c; b++) g = l[b], g.nTf = a[b].cell, g.sClass && d(g.nTf).addClass(g.sClass);
            }
        }
        function J(a, b, e) {
            var f, g, h, i = [], j = [], k = a.aoColumns.length, l;
            if (b) {
                e === c && (e = !1);
                f = 0;
                for (g = b.length; f < g; f++) {
                    i[f] = b[f].slice();
                    i[f].nTr = b[f].nTr;
                    for (h = k - 1; 0 <= h; h--) !a.aoColumns[h].bVisible && !e && i[f].splice(h, 1);
                    j.push([]);
                }
                f = 0;
                for (g = i.length; f < g; f++) {
                    if (a = i[f].nTr) for (;h = a.firstChild; ) a.removeChild(h);
                    h = 0;
                    for (b = i[f].length; h < b; h++) if (l = k = 1, j[f][h] === c) {
                        a.appendChild(i[f][h].cell);
                        for (j[f][h] = 1; i[f + k] !== c && i[f][h].cell == i[f + k][h].cell; ) j[f + k][h] = 1, 
                        k++;
                        for (;i[f][h + l] !== c && i[f][h].cell == i[f][h + l].cell; ) {
                            for (e = 0; e < k; e++) j[f + e][h + l] = 1;
                            l++;
                        }
                        d(i[f][h].cell).attr("rowspan", k).attr("colspan", l);
                    }
                }
            }
        }
        function K(a) {
            var b = Nb(a, "aoPreDrawCallback", "preDraw", [ a ]);
            if (-1 !== d.inArray(!1, b)) mb(a, !1); else {
                var b = [], e = 0, f = a.asStripeClasses, g = f.length, h = a.oLanguage, i = a.iInitDisplayStart, j = "ssp" == Qb(a), k = a.aiDisplay;
                a.bDrawing = !0;
                i !== c && -1 !== i && (a._iDisplayStart = j ? i : i >= a.fnRecordsDisplay() ? 0 : i, 
                a.iInitDisplayStart = -1);
                var i = a._iDisplayStart, l = a.fnDisplayEnd();
                if (a.bDeferLoading) a.bDeferLoading = !1, a.iDraw++, mb(a, !1); else if (j) {
                    if (!a.bDestroying && !Q(a)) return;
                } else a.iDraw++;
                if (0 !== k.length) {
                    h = j ? a.aoData.length : l;
                    for (j = j ? 0 : i; j < h; j++) {
                        var m = k[j], n = a.aoData[m];
                        null === n.nTr && G(a, m);
                        m = n.nTr;
                        if (0 !== g) {
                            var o = f[e % g];
                            n._sRowStripe != o && (d(m).removeClass(n._sRowStripe).addClass(o), n._sRowStripe = o);
                        }
                        Nb(a, "aoRowCallback", null, [ m, n._aData, e, j ]);
                        b.push(m);
                        e++;
                    }
                } else e = h.sZeroRecords, 1 == a.iDraw && "ajax" == Qb(a) ? e = h.sLoadingRecords : h.sEmptyTable && 0 === a.fnRecordsTotal() && (e = h.sEmptyTable), 
                b[0] = d("<tr/>", {
                    "class": g ? f[0] : ""
                }).append(d("<td />", {
                    valign: "top",
                    colSpan: q(a),
                    "class": a.oClasses.sRowEmpty
                }).html(e))[0];
                Nb(a, "aoHeaderCallback", "header", [ d(a.nTHead).children("tr")[0], B(a), i, l, k ]);
                Nb(a, "aoFooterCallback", "footer", [ d(a.nTFoot).children("tr")[0], B(a), i, l, k ]);
                f = d(a.nTBody);
                f.children().detach();
                f.append(d(b));
                Nb(a, "aoDrawCallback", "draw", [ a ]);
                a.bSorted = !1;
                a.bFiltered = !1;
                a.bDrawing = !1;
            }
        }
        function L(a, b) {
            var c = a.oFeatures, d = c.bFilter;
            c.bSort && zb(a);
            d ? V(a, a.oPreviousSearch) : a.aiDisplay = a.aiDisplayMaster.slice();
            !0 !== b && (a._iDisplayStart = 0);
            a._drawHold = b;
            K(a);
            a._drawHold = !1;
        }
        function M(a) {
            var b = a.oClasses, c = d(a.nTable), c = d("<div/>").insertBefore(c), e = a.oFeatures, f = d("<div/>", {
                id: a.sTableId + "_wrapper",
                "class": b.sWrapper + (a.nTFoot ? "" : " " + b.sNoFooter)
            });
            a.nHolding = c[0];
            a.nTableWrapper = f[0];
            a.nTableReinsertBefore = a.nTable.nextSibling;
            for (var g = a.sDom.split(""), h, i, j, k, l, m, n = 0; n < g.length; n++) {
                h = null;
                i = g[n];
                if ("<" == i) {
                    j = d("<div/>")[0];
                    k = g[n + 1];
                    if ("'" == k || '"' == k) {
                        l = "";
                        for (m = 2; g[n + m] != k; ) l += g[n + m], m++;
                        "H" == l ? l = b.sJUIHeader : "F" == l && (l = b.sJUIFooter);
                        -1 != l.indexOf(".") ? (k = l.split("."), j.id = k[0].substr(1, k[0].length - 1), 
                        j.className = k[1]) : "#" == l.charAt(0) ? j.id = l.substr(1, l.length - 1) : j.className = l;
                        n += m;
                    }
                    f.append(j);
                    f = d(j);
                } else if (">" == i) f = f.parent(); else if ("l" == i && e.bPaginate && e.bLengthChange) h = ib(a); else if ("f" == i && e.bFilter) h = U(a); else if ("r" == i && e.bProcessing) h = lb(a); else if ("t" == i) h = nb(a); else if ("i" == i && e.bInfo) h = cb(a); else if ("p" == i && e.bPaginate) h = jb(a); else if (0 !== Ub.ext.feature.length) {
                    j = Ub.ext.feature;
                    m = 0;
                    for (k = j.length; m < k; m++) if (i == j[m].cFeature) {
                        h = j[m].fnInit(a);
                        break;
                    }
                }
                h && (j = a.aanFeatures, j[i] || (j[i] = []), j[i].push(h), f.append(h));
            }
            c.replaceWith(f);
        }
        function N(a, b) {
            var c = d(b).children("tr"), e, f, g, h, i, j, k, l, m, n;
            a.splice(0, a.length);
            g = 0;
            for (j = c.length; g < j; g++) a.push([]);
            g = 0;
            for (j = c.length; g < j; g++) {
                e = c[g];
                for (f = e.firstChild; f; ) {
                    if ("TD" == f.nodeName.toUpperCase() || "TH" == f.nodeName.toUpperCase()) {
                        l = 1 * f.getAttribute("colspan");
                        m = 1 * f.getAttribute("rowspan");
                        l = !l || 0 === l || 1 === l ? 1 : l;
                        m = !m || 0 === m || 1 === m ? 1 : m;
                        h = 0;
                        for (i = a[g]; i[h]; ) h++;
                        k = h;
                        n = 1 === l ? !0 : !1;
                        for (i = 0; i < l; i++) for (h = 0; h < m; h++) a[g + h][k + i] = {
                            cell: f,
                            unique: n
                        }, a[g + h].nTr = e;
                    }
                    f = f.nextSibling;
                }
            }
        }
        function O(a, b, c) {
            var d = [];
            c || (c = a.aoHeader, b && (c = [], N(c, b)));
            for (var b = 0, e = c.length; b < e; b++) for (var f = 0, g = c[b].length; f < g; f++) if (c[b][f].unique && (!d[f] || !a.bSortCellsTop)) d[f] = c[b][f].cell;
            return d;
        }
        function P(a, b, c) {
            Nb(a, "aoServerParams", "serverParams", [ b ]);
            if (b && d.isArray(b)) {
                var e = {}, f = /(.*?)\[\]$/;
                d.each(b, function(a, b) {
                    var c = b.name.match(f);
                    c ? (c = c[0], e[c] || (e[c] = []), e[c].push(b.value)) : e[b.name] = b.value;
                });
                b = e;
            }
            var g, h = a.ajax, i = a.oInstance;
            if (d.isPlainObject(h) && h.data) {
                g = h.data;
                var j = d.isFunction(g) ? g(b) : g, b = d.isFunction(g) && j ? j : d.extend(!0, b, j);
                delete h.data;
            }
            j = {
                data: b,
                success: function(b) {
                    var d = b.error || b.sError;
                    d && a.oApi._fnLog(a, 0, d);
                    a.json = b;
                    Nb(a, null, "xhr", [ a, b ]);
                    c(b);
                },
                dataType: "json",
                cache: !1,
                type: a.sServerMethod,
                error: function(b, c) {
                    var d = a.oApi._fnLog;
                    "parsererror" == c ? d(a, 0, "Invalid JSON response", 1) : 4 === b.readyState && d(a, 0, "Ajax error", 7);
                    mb(a, !1);
                }
            };
            a.oAjaxData = b;
            Nb(a, null, "preXhr", [ a, b ]);
            a.fnServerData ? a.fnServerData.call(i, a.sAjaxSource, d.map(b, function(a, b) {
                return {
                    name: b,
                    value: a
                };
            }), c, a) : a.sAjaxSource || "string" === typeof h ? a.jqXHR = d.ajax(d.extend(j, {
                url: h || a.sAjaxSource
            })) : d.isFunction(h) ? a.jqXHR = h.call(i, b, c, a) : (a.jqXHR = d.ajax(d.extend(j, h)), 
            h.data = g);
        }
        function Q(a) {
            return a.bAjaxDataGet ? (a.iDraw++, mb(a, !0), P(a, R(a), function(b) {
                S(a, b);
            }), !1) : !0;
        }
        function R(a) {
            var b = a.aoColumns, c = b.length, e = a.oFeatures, f = a.oPreviousSearch, g = a.aoPreSearchCols, h, i = [], j, k, l, m = yb(a);
            h = a._iDisplayStart;
            j = !1 !== e.bPaginate ? a._iDisplayLength : -1;
            var n = function(a, b) {
                i.push({
                    name: a,
                    value: b
                });
            };
            n("sEcho", a.iDraw);
            n("iColumns", c);
            n("sColumns", jc(b, "sName").join(","));
            n("iDisplayStart", h);
            n("iDisplayLength", j);
            var o = {
                draw: a.iDraw,
                columns: [],
                order: [],
                start: h,
                length: j,
                search: {
                    value: f.sSearch,
                    regex: f.bRegex
                }
            };
            for (h = 0; h < c; h++) k = b[h], l = g[h], j = "function" == typeof k.mData ? "function" : k.mData, 
            o.columns.push({
                data: j,
                name: k.sName,
                searchable: k.bSearchable,
                orderable: k.bSortable,
                search: {
                    value: l.sSearch,
                    regex: l.bRegex
                }
            }), n("mDataProp_" + h, j), e.bFilter && (n("sSearch_" + h, l.sSearch), n("bRegex_" + h, l.bRegex), 
            n("bSearchable_" + h, k.bSearchable)), e.bSort && n("bSortable_" + h, k.bSortable);
            e.bFilter && (n("sSearch", f.sSearch), n("bRegex", f.bRegex));
            e.bSort && (d.each(m, function(a, b) {
                o.order.push({
                    column: b.col,
                    dir: b.dir
                });
                n("iSortCol_" + a, b.col);
                n("sSortDir_" + a, b.dir);
            }), n("iSortingCols", m.length));
            b = Ub.ext.legacy.ajax;
            return null === b ? a.sAjaxSource ? i : o : b ? i : o;
        }
        function S(a, b) {
            var d = b.sEcho !== c ? b.sEcho : b.draw, e = b.iTotalRecords !== c ? b.iTotalRecords : b.recordsTotal, f = b.iTotalDisplayRecords !== c ? b.iTotalDisplayRecords : b.recordsFiltered;
            if (d) {
                if (1 * d < a.iDraw) return;
                a.iDraw = 1 * d;
            }
            C(a);
            a._iRecordsTotal = parseInt(e, 10);
            a._iRecordsDisplay = parseInt(f, 10);
            d = T(a, b);
            e = 0;
            for (f = d.length; e < f; e++) u(a, d[e]);
            a.aiDisplay = a.aiDisplayMaster.slice();
            a.bAjaxDataGet = !1;
            K(a);
            a._bInitComplete || gb(a, b);
            a.bAjaxDataGet = !0;
            mb(a, !1);
        }
        function T(a, b) {
            var e = d.isPlainObject(a.ajax) && a.ajax.dataSrc !== c ? a.ajax.dataSrc : a.sAjaxDataProp;
            return "data" === e ? b.aaData || b[e] : "" !== e ? z(e)(b) : b;
        }
        function U(a) {
            var c = a.oClasses, e = a.sTableId, f = a.oLanguage, g = a.oPreviousSearch, h = a.aanFeatures, i = '<input type="search" class="' + c.sFilterInput + '"/>', j = f.sSearch, j = j.match(/_INPUT_/) ? j.replace("_INPUT_", i) : j + i, c = d("<div/>", {
                id: !h.f ? e + "_filter" : null,
                "class": c.sFilter
            }).append(d("<label/>").append(j)), h = function() {
                var b = !this.value ? "" : this.value;
                b != g.sSearch && (V(a, {
                    sSearch: b,
                    bRegex: g.bRegex,
                    bSmart: g.bSmart,
                    bCaseInsensitive: g.bCaseInsensitive
                }), a._iDisplayStart = 0, K(a));
            }, k = d("input", c).val(g.sSearch).attr("placeholder", f.sSearchPlaceholder).bind("keyup.DT search.DT input.DT paste.DT cut.DT", "ssp" === Qb(a) ? rb(h, 400) : h).bind("keypress.DT", function(a) {
                if (13 == a.keyCode) return !1;
            }).attr("aria-controls", e);
            d(a.nTable).on("search.dt.DT", function(c, d) {
                if (a === d) try {
                    k[0] !== b.activeElement && k.val(g.sSearch);
                } catch (e) {}
            });
            return c[0];
        }
        function V(a, b, d) {
            var e = a.oPreviousSearch, f = a.aoPreSearchCols, g = function(a) {
                e.sSearch = a.sSearch;
                e.bRegex = a.bRegex;
                e.bSmart = a.bSmart;
                e.bCaseInsensitive = a.bCaseInsensitive;
            };
            s(a);
            if ("ssp" != Qb(a)) {
                Y(a, b.sSearch, d, b.bEscapeRegex !== c ? !b.bEscapeRegex : b.bRegex, b.bSmart, b.bCaseInsensitive);
                g(b);
                for (b = 0; b < f.length; b++) X(a, f[b].sSearch, b, f[b].bEscapeRegex !== c ? !f[b].bEscapeRegex : f[b].bRegex, f[b].bSmart, f[b].bCaseInsensitive);
                W(a);
            } else g(b);
            a.bFiltered = !0;
            Nb(a, null, "search", [ a ]);
        }
        function W(a) {
            for (var b = Ub.ext.search, c = a.aiDisplay, d, e, f = 0, g = b.length; f < g; f++) {
                for (var h = [], i = 0, j = c.length; i < j; i++) e = c[i], d = a.aoData[e], b[f](a, d._aFilterData, e, d._aData, i) && h.push(e);
                c.length = 0;
                c.push.apply(c, h);
            }
        }
        function X(a, b, c, d, e, f) {
            if ("" !== b) for (var g = a.aiDisplay, d = Z(b, d, e, f), e = g.length - 1; 0 <= e; e--) b = a.aoData[g[e]]._aFilterData[c], 
            d.test(b) || g.splice(e, 1);
        }
        function Y(a, b, c, d, e, f) {
            var d = Z(b, d, e, f), e = a.oPreviousSearch.sSearch, f = a.aiDisplayMaster, g;
            0 !== Ub.ext.search.length && (c = !0);
            g = _(a);
            if (0 >= b.length) a.aiDisplay = f.slice(); else {
                if (g || c || e.length > b.length || 0 !== b.indexOf(e) || a.bSorted) a.aiDisplay = f.slice();
                b = a.aiDisplay;
                for (c = b.length - 1; 0 <= c; c--) d.test(a.aoData[b[c]]._sFilterRow) || b.splice(c, 1);
            }
        }
        function Z(a, b, c, e) {
            a = b ? a : $(a);
            c && (a = "^(?=.*?" + d.map(a.match(/"[^"]+"|[^ ]+/g) || "", function(a) {
                return '"' === a.charAt(0) ? a.match(/^"(.*)"$/)[1] : a;
            }).join(")(?=.*?") + ").*$");
            return RegExp(a, e ? "i" : "");
        }
        function $(a) {
            return a.replace(cc, "\\$1");
        }
        function _(a) {
            var b = a.aoColumns, c, d, e, f, g, h, i, j, k = Ub.ext.type.search;
            c = !1;
            d = 0;
            for (f = a.aoData.length; d < f; d++) if (j = a.aoData[d], !j._aFilterData) {
                h = [];
                e = 0;
                for (g = b.length; e < g; e++) c = b[e], c.bSearchable ? (i = w(a, d, e, "filter"), 
                k[c.sType] && (i = k[c.sType](i)), null === i && (i = ""), "string" !== typeof i && i.toString && (i = i.toString())) : i = "", 
                i.indexOf && -1 !== i.indexOf("&") && (qc.innerHTML = i, i = rc ? qc.textContent : qc.innerText), 
                i.replace && (i = i.replace(/[\r\n]/g, "")), h.push(i);
                j._aFilterData = h;
                j._sFilterRow = h.join("  ");
                c = !0;
            }
            return c;
        }
        function ab(a) {
            return {
                search: a.sSearch,
                smart: a.bSmart,
                regex: a.bRegex,
                caseInsensitive: a.bCaseInsensitive
            };
        }
        function bb(a) {
            return {
                sSearch: a.search,
                bSmart: a.smart,
                bRegex: a.regex,
                bCaseInsensitive: a.caseInsensitive
            };
        }
        function cb(a) {
            var b = a.sTableId, c = a.aanFeatures.i, e = d("<div/>", {
                "class": a.oClasses.sInfo,
                id: !c ? b + "_info" : null
            });
            c || (a.aoDrawCallback.push({
                fn: db,
                sName: "information"
            }), e.attr("role", "status").attr("aria-live", "polite"), d(a.nTable).attr("aria-describedby", b + "_info"));
            return e[0];
        }
        function db(a) {
            var b = a.aanFeatures.i;
            if (0 !== b.length) {
                var c = a.oLanguage, e = a._iDisplayStart + 1, f = a.fnDisplayEnd(), g = a.fnRecordsTotal(), h = a.fnRecordsDisplay(), i = h ? c.sInfo : c.sInfoEmpty;
                h !== g && (i += " " + c.sInfoFiltered);
                i += c.sInfoPostFix;
                i = eb(a, i);
                c = c.fnInfoCallback;
                null !== c && (i = c.call(a.oInstance, a, e, f, g, h, i));
                d(b).html(i);
            }
        }
        function eb(a, b) {
            var c = a.fnFormatNumber, d = a._iDisplayStart + 1, e = a._iDisplayLength, f = a.fnRecordsDisplay(), g = -1 === e;
            return b.replace(/_START_/g, c.call(a, d)).replace(/_END_/g, c.call(a, a.fnDisplayEnd())).replace(/_MAX_/g, c.call(a, a.fnRecordsTotal())).replace(/_TOTAL_/g, c.call(a, f)).replace(/_PAGE_/g, c.call(a, g ? 1 : Math.ceil(d / e))).replace(/_PAGES_/g, c.call(a, g ? 1 : Math.ceil(f / e)));
        }
        function fb(a) {
            var b, c, d = a.iInitDisplayStart, e = a.aoColumns, f;
            c = a.oFeatures;
            if (a.bInitialised) {
                M(a);
                I(a);
                J(a, a.aoHeader);
                J(a, a.aoFooter);
                mb(a, !0);
                c.bAutoWidth && qb(a);
                b = 0;
                for (c = e.length; b < c; b++) f = e[b], f.sWidth && (f.nTh.style.width = wb(f.sWidth));
                L(a);
                e = Qb(a);
                "ssp" != e && ("ajax" == e ? P(a, [], function(c) {
                    var e = T(a, c);
                    for (b = 0; b < e.length; b++) u(a, e[b]);
                    a.iInitDisplayStart = d;
                    L(a);
                    mb(a, !1);
                    gb(a, c);
                }, a) : (mb(a, !1), gb(a)));
            } else setTimeout(function() {
                fb(a);
            }, 200);
        }
        function gb(a, b) {
            a._bInitComplete = !0;
            b && n(a);
            Nb(a, "aoInitComplete", "init", [ a, b ]);
        }
        function hb(a, b) {
            var c = parseInt(b, 10);
            a._iDisplayLength = c;
            Ob(a);
            Nb(a, null, "length", [ a, c ]);
        }
        function ib(a) {
            for (var b = a.oClasses, c = a.sTableId, e = a.aLengthMenu, f = d.isArray(e[0]), g = f ? e[0] : e, e = f ? e[1] : e, f = d("<select/>", {
                name: c + "_length",
                "aria-controls": c,
                "class": b.sLengthSelect
            }), h = 0, i = g.length; h < i; h++) f[0][h] = new Option(e[h], g[h]);
            var j = d("<div><label/></div>").addClass(b.sLength);
            a.aanFeatures.l || (j[0].id = c + "_length");
            j.children().append(a.oLanguage.sLengthMenu.replace("_MENU_", f[0].outerHTML));
            d("select", j).val(a._iDisplayLength).bind("change.DT", function() {
                hb(a, d(this).val());
                K(a);
            });
            d(a.nTable).bind("length.dt.DT", function(b, c, e) {
                a === c && d("select", j).val(e);
            });
            return j[0];
        }
        function jb(a) {
            var b = a.sPaginationType, c = Ub.ext.pager[b], e = "function" === typeof c, f = function(a) {
                K(a);
            }, b = d("<div/>").addClass(a.oClasses.sPaging + b)[0], g = a.aanFeatures;
            e || c.fnInit(a, b, f);
            g.p || (b.id = a.sTableId + "_paginate", a.aoDrawCallback.push({
                fn: function(a) {
                    if (e) {
                        var b = a._iDisplayStart, d = a._iDisplayLength, h = a.fnRecordsDisplay(), i = -1 === d, b = i ? 0 : Math.ceil(b / d), d = i ? 1 : Math.ceil(h / d), h = c(b, d), j, i = 0;
                        for (j = g.p.length; i < j; i++) Pb(a, "pageButton")(a, g.p[i], i, h, b, d);
                    } else c.fnUpdate(a, f);
                },
                sName: "pagination"
            }));
            return b;
        }
        function kb(a, b, c) {
            var d = a._iDisplayStart, e = a._iDisplayLength, f = a.fnRecordsDisplay();
            0 === f || -1 === e ? d = 0 : "number" === typeof b ? (d = b * e, d > f && (d = 0)) : "first" == b ? d = 0 : "previous" == b ? (d = 0 <= e ? d - e : 0, 
            0 > d && (d = 0)) : "next" == b ? d + e < f && (d += e) : "last" == b ? d = Math.floor((f - 1) / e) * e : Ib(a, 0, "Unknown paging action: " + b, 5);
            b = a._iDisplayStart !== d;
            a._iDisplayStart = d;
            b && (Nb(a, null, "page", [ a ]), c && K(a));
            return b;
        }
        function lb(a) {
            return d("<div/>", {
                id: !a.aanFeatures.r ? a.sTableId + "_processing" : null,
                "class": a.oClasses.sProcessing
            }).html(a.oLanguage.sProcessing).insertBefore(a.nTable)[0];
        }
        function mb(a, b) {
            a.oFeatures.bProcessing && d(a.aanFeatures.r).css("display", b ? "block" : "none");
            Nb(a, null, "processing", [ a, b ]);
        }
        function nb(a) {
            var b = d(a.nTable);
            b.attr("role", "grid");
            var c = a.oScroll;
            if ("" === c.sX && "" === c.sY) return a.nTable;
            var e = c.sX, f = c.sY, g = a.oClasses, h = b.children("caption"), i = h.length ? h[0]._captionSide : null, j = d(b[0].cloneNode(!1)), k = d(b[0].cloneNode(!1)), l = b.children("tfoot");
            c.sX && "100%" === b.attr("width") && b.removeAttr("width");
            l.length || (l = null);
            c = d("<div/>", {
                "class": g.sScrollWrapper
            }).append(d("<div/>", {
                "class": g.sScrollHead
            }).css({
                overflow: "hidden",
                position: "relative",
                border: 0,
                width: e ? !e ? null : wb(e) : "100%"
            }).append(d("<div/>", {
                "class": g.sScrollHeadInner
            }).css({
                "box-sizing": "content-box",
                width: c.sXInner || "100%"
            }).append(j.removeAttr("id").css("margin-left", 0).append(b.children("thead")))).append("top" === i ? h : null)).append(d("<div/>", {
                "class": g.sScrollBody
            }).css({
                overflow: "auto",
                height: !f ? null : wb(f),
                width: !e ? null : wb(e)
            }).append(b));
            l && c.append(d("<div/>", {
                "class": g.sScrollFoot
            }).css({
                overflow: "hidden",
                border: 0,
                width: e ? !e ? null : wb(e) : "100%"
            }).append(d("<div/>", {
                "class": g.sScrollFootInner
            }).append(k.removeAttr("id").css("margin-left", 0).append(b.children("tfoot")))).append("bottom" === i ? h : null));
            var b = c.children(), m = b[0], g = b[1], n = l ? b[2] : null;
            e && d(g).scroll(function() {
                var a = this.scrollLeft;
                m.scrollLeft = a;
                l && (n.scrollLeft = a);
            });
            a.nScrollHead = m;
            a.nScrollBody = g;
            a.nScrollFoot = n;
            a.aoDrawCallback.push({
                fn: ob,
                sName: "scrolling"
            });
            return c[0];
        }
        function ob(a) {
            var b = a.oScroll, c = b.sX, e = b.sXInner, f = b.sY, g = b.iBarWidth, h = d(a.nScrollHead), i = h[0].style, j = h.children("div"), k = j[0].style, l = j.children("table"), j = a.nScrollBody, m = d(j), n = j.style, p = d(a.nScrollFoot).children("div"), q = p.children("table"), r = d(a.nTHead), s = d(a.nTable), t = s[0], u = t.style, v = a.nTFoot ? d(a.nTFoot) : null, w = a.oBrowser, x = w.bScrollOversize, y, z, A, B, C, D = [], E = [], F = [], G, H = function(a) {
                a = a.style;
                a.paddingTop = "0";
                a.paddingBottom = "0";
                a.borderTopWidth = "0";
                a.borderBottomWidth = "0";
                a.height = 0;
            };
            s.children("thead, tfoot").remove();
            C = r.clone().prependTo(s);
            y = r.find("tr");
            A = C.find("tr");
            C.find("th, td").removeAttr("tabindex");
            v && (B = v.clone().prependTo(s), z = v.find("tr"), B = B.find("tr"));
            c || (n.width = "100%", h[0].style.width = "100%");
            d.each(O(a, C), function(b, c) {
                G = o(a, b);
                c.style.width = a.aoColumns[G].sWidth;
            });
            v && pb(function(a) {
                a.style.width = "";
            }, B);
            b.bCollapse && "" !== f && (n.height = m[0].offsetHeight + r[0].offsetHeight + "px");
            h = s.outerWidth();
            if ("" === c) {
                if (u.width = "100%", x && (s.find("tbody").height() > j.offsetHeight || "scroll" == m.css("overflow-y"))) u.width = wb(s.outerWidth() - g);
            } else "" !== e ? u.width = wb(e) : h == m.width() && m.height() < s.height() ? (u.width = wb(h - g), 
            s.outerWidth() > h - g && (u.width = wb(h))) : u.width = wb(h);
            h = s.outerWidth();
            pb(H, A);
            pb(function(a) {
                F.push(a.innerHTML);
                D.push(wb(d(a).css("width")));
            }, A);
            pb(function(a, b) {
                a.style.width = D[b];
            }, y);
            d(A).height(0);
            v && (pb(H, B), pb(function(a) {
                E.push(wb(d(a).css("width")));
            }, B), pb(function(a, b) {
                a.style.width = E[b];
            }, z), d(B).height(0));
            pb(function(a, b) {
                a.innerHTML = '<div class="dataTables_sizing" style="height:0;overflow:hidden;">' + F[b] + "</div>";
                a.style.width = D[b];
            }, A);
            v && pb(function(a, b) {
                a.innerHTML = "";
                a.style.width = E[b];
            }, B);
            if (s.outerWidth() < h) {
                z = j.scrollHeight > j.offsetHeight || "scroll" == m.css("overflow-y") ? h + g : h;
                if (x && (j.scrollHeight > j.offsetHeight || "scroll" == m.css("overflow-y"))) u.width = wb(z - g);
                ("" === c || "" !== e) && Ib(a, 1, "Possible column misalignment", 6);
            } else z = "100%";
            n.width = wb(z);
            i.width = wb(z);
            v && (a.nScrollFoot.style.width = wb(z));
            !f && x && (n.height = wb(t.offsetHeight + g));
            f && b.bCollapse && (n.height = wb(f), b = c && t.offsetWidth > j.offsetWidth ? g : 0, 
            t.offsetHeight < j.offsetHeight && (n.height = wb(t.offsetHeight + b)));
            b = s.outerWidth();
            l[0].style.width = wb(b);
            k.width = wb(b);
            l = s.height() > j.clientHeight || "scroll" == m.css("overflow-y");
            w = "padding" + (w.bScrollbarLeft ? "Left" : "Right");
            k[w] = l ? g + "px" : "0px";
            v && (q[0].style.width = wb(b), p[0].style.width = wb(b), p[0].style[w] = l ? g + "px" : "0px");
            m.scroll();
            if ((a.bSorted || a.bFiltered) && !a._drawHold) j.scrollTop = 0;
        }
        function pb(a, b, c) {
            for (var d = 0, e = 0, f = b.length, g, h; e < f; ) {
                g = b[e].firstChild;
                for (h = c ? c[e].firstChild : null; g; ) 1 === g.nodeType && (c ? a(g, h, d) : a(g, d), 
                d++), g = g.nextSibling, h = c ? h.nextSibling : null;
                e++;
            }
        }
        function qb(b) {
            var c = b.nTable, e = b.aoColumns, f = b.oScroll, g = f.sY, h = f.sX, i = f.sXInner, j = e.length, f = r(b, "bVisible"), k = d("th", b.nTHead), l = c.getAttribute("width"), m = c.parentNode, o = !1, p, s;
            for (p = 0; p < f.length; p++) s = e[f[p]], null !== s.sWidth && (s.sWidth = sb(s.sWidthOrig, m), 
            o = !0);
            if (!o && !h && !g && j == q(b) && j == k.length) for (p = 0; p < j; p++) e[p].sWidth = wb(k.eq(p).width()); else {
                j = d(c).clone().empty().css("visibility", "hidden").removeAttr("id").append(d(b.nTHead).clone(!1)).append(d(b.nTFoot).clone(!1)).append(d("<tbody><tr/></tbody>"));
                j.find("tfoot th, tfoot td").css("width", "");
                var t = j.find("tbody tr"), k = O(b, j.find("thead")[0]);
                for (p = 0; p < f.length; p++) s = e[f[p]], k[p].style.width = null !== s.sWidthOrig && "" !== s.sWidthOrig ? wb(s.sWidthOrig) : "";
                if (b.aoData.length) for (p = 0; p < f.length; p++) o = f[p], s = e[o], d(ub(b, o)).clone(!1).append(s.sContentPadding).appendTo(t);
                j.appendTo(m);
                h && i ? j.width(i) : h ? (j.css("width", "auto"), j.width() < m.offsetWidth && j.width(m.offsetWidth)) : g ? j.width(m.offsetWidth) : l && j.width(l);
                tb(b, j[0]);
                if (h) {
                    for (p = i = 0; p < f.length; p++) s = e[f[p]], g = d(k[p]).outerWidth(), i += null === s.sWidthOrig ? g : parseInt(s.sWidth, 10) + g - d(k[p]).width();
                    j.width(wb(i));
                    c.style.width = wb(i);
                }
                for (p = 0; p < f.length; p++) if (s = e[f[p]], g = d(k[p]).width()) s.sWidth = wb(g);
                c.style.width = wb(j.css("width"));
                j.remove();
            }
            l && (c.style.width = wb(l));
            if ((l || h) && !b._reszEvt) d(a).bind("resize.DT-" + b.sInstance, rb(function() {
                n(b);
            })), b._reszEvt = !0;
        }
        function rb(a, b) {
            var d = b || 200, e, f;
            return function() {
                var b = this, g = +new Date(), h = arguments;
                e && g < e + d ? (clearTimeout(f), f = setTimeout(function() {
                    e = c;
                    a.apply(b, h);
                }, d)) : e ? (e = g, a.apply(b, h)) : e = g;
            };
        }
        function sb(a, c) {
            if (!a) return 0;
            var e = d("<div/>").css("width", wb(a)).appendTo(c || b.body), f = e[0].offsetWidth;
            e.remove();
            return f;
        }
        function tb(a, b) {
            var c = a.oScroll;
            if (c.sX || c.sY) c = !c.sX ? c.iBarWidth : 0, b.style.width = wb(d(b).outerWidth() - c);
        }
        function ub(a, b) {
            var c = vb(a, b);
            if (0 > c) return null;
            var e = a.aoData[c];
            return !e.nTr ? d("<td/>").html(w(a, c, b, "display"))[0] : e.anCells[b];
        }
        function vb(a, b) {
            for (var c, d = -1, e = -1, f = 0, g = a.aoData.length; f < g; f++) c = w(a, f, b, "display") + "", 
            c = c.replace(sc, ""), c.length > d && (d = c.length, e = f);
            return e;
        }
        function wb(a) {
            return null === a ? "0px" : "number" == typeof a ? 0 > a ? "0px" : a + "px" : a.match(/\d$/) ? a + "px" : a;
        }
        function xb() {
            if (!Ub.__scrollbarWidth) {
                var a = d("<p/>").css({
                    width: "100%",
                    height: 200,
                    padding: 0
                })[0], b = d("<div/>").css({
                    position: "absolute",
                    top: 0,
                    left: 0,
                    width: 200,
                    height: 150,
                    padding: 0,
                    overflow: "hidden",
                    visibility: "hidden"
                }).append(a).appendTo("body"), c = a.offsetWidth;
                b.css("overflow", "scroll");
                a = a.offsetWidth;
                c === a && (a = b[0].clientWidth);
                b.remove();
                Ub.__scrollbarWidth = c - a;
            }
            return Ub.__scrollbarWidth;
        }
        function yb(a) {
            var b, c, e = [], f = a.aoColumns, g, h, i, j;
            b = a.aaSortingFixed;
            c = d.isPlainObject(b);
            var k = [];
            g = function(a) {
                a.length && !d.isArray(a[0]) ? k.push(a) : k.push.apply(k, a);
            };
            d.isArray(b) && g(b);
            c && b.pre && g(b.pre);
            g(a.aaSorting);
            c && b.post && g(b.post);
            for (a = 0; a < k.length; a++) {
                j = k[a][0];
                g = f[j].aDataSort;
                b = 0;
                for (c = g.length; b < c; b++) h = g[b], i = f[h].sType || "string", e.push({
                    src: j,
                    col: h,
                    dir: k[a][1],
                    index: k[a][2],
                    type: i,
                    formatter: Ub.ext.type.order[i + "-pre"]
                });
            }
            return e;
        }
        function zb(a) {
            var b, c, d = [], e = Ub.ext.type.order, f = a.aoData, g = 0, h, i = a.aiDisplayMaster, j;
            s(a);
            j = yb(a);
            b = 0;
            for (c = j.length; b < c; b++) h = j[b], h.formatter && g++, Eb(a, h.col);
            if ("ssp" != Qb(a) && 0 !== j.length) {
                b = 0;
                for (c = i.length; b < c; b++) d[i[b]] = b;
                g === j.length ? i.sort(function(a, b) {
                    var c, e, g, h, i = j.length, k = f[a]._aSortData, l = f[b]._aSortData;
                    for (g = 0; g < i; g++) if (h = j[g], c = k[h.col], e = l[h.col], c = c < e ? -1 : c > e ? 1 : 0, 
                    0 !== c) return "asc" === h.dir ? c : -c;
                    c = d[a];
                    e = d[b];
                    return c < e ? -1 : c > e ? 1 : 0;
                }) : i.sort(function(a, b) {
                    var c, g, h, i, k = j.length, l = f[a]._aSortData, m = f[b]._aSortData;
                    for (h = 0; h < k; h++) if (i = j[h], c = l[i.col], g = m[i.col], i = e[i.type + "-" + i.dir] || e["string-" + i.dir], 
                    c = i(c, g), 0 !== c) return c;
                    c = d[a];
                    g = d[b];
                    return c < g ? -1 : c > g ? 1 : 0;
                });
            }
            a.bSorted = !0;
        }
        function Ab(a) {
            for (var b, c, d = a.aoColumns, e = yb(a), a = a.oLanguage.oAria, f = 0, g = d.length; f < g; f++) {
                c = d[f];
                var h = c.asSorting;
                b = c.sTitle.replace(/<.*?>/g, "");
                var i = c.nTh;
                i.removeAttribute("aria-sort");
                c.bSortable && (0 < e.length && e[0].col == f ? (i.setAttribute("aria-sort", "asc" == e[0].dir ? "ascending" : "descending"), 
                c = h[e[0].index + 1] || h[0]) : c = h[0], b += "asc" === c ? a.sSortAscending : a.sSortDescending);
                i.setAttribute("aria-label", b);
            }
        }
        function Bb(a, b, e, f) {
            var g = a.aaSorting, h = a.aoColumns[b].asSorting, i = function(a) {
                var b = a._idx;
                b === c && (b = d.inArray(a[1], h));
                return b + 1 >= h.length ? 0 : b + 1;
            };
            "number" === typeof g[0] && (g = a.aaSorting = [ g ]);
            e && a.oFeatures.bSortMulti ? (e = d.inArray(b, jc(g, "0")), -1 !== e ? (b = i(g[e]), 
            g[e][1] = h[b], g[e]._idx = b) : (g.push([ b, h[0], 0 ]), g[g.length - 1]._idx = 0)) : g.length && g[0][0] == b ? (b = i(g[0]), 
            g.length = 1, g[0][1] = h[b], g[0]._idx = b) : (g.length = 0, g.push([ b, h[0] ]), 
            g[0]._idx = 0);
            L(a);
            "function" == typeof f && f(a);
        }
        function Cb(a, b, c, d) {
            var e = a.aoColumns[c];
            Lb(b, {}, function(b) {
                !1 !== e.bSortable && (a.oFeatures.bProcessing ? (mb(a, !0), setTimeout(function() {
                    Bb(a, c, b.shiftKey, d);
                    "ssp" !== Qb(a) && mb(a, !1);
                }, 0)) : Bb(a, c, b.shiftKey, d));
            });
        }
        function Db(a) {
            var b = a.aLastSort, c = a.oClasses.sSortColumn, e = yb(a), f = a.oFeatures, g, h;
            if (f.bSort && f.bSortClasses) {
                f = 0;
                for (g = b.length; f < g; f++) h = b[f].src, d(jc(a.aoData, "anCells", h)).removeClass(c + (2 > f ? f + 1 : 3));
                f = 0;
                for (g = e.length; f < g; f++) h = e[f].src, d(jc(a.aoData, "anCells", h)).addClass(c + (2 > f ? f + 1 : 3));
            }
            a.aLastSort = e;
        }
        function Eb(a, b) {
            var c = a.aoColumns[b], d = Ub.ext.order[c.sSortDataType], e;
            d && (e = d.call(a.oInstance, a, b, p(a, b)));
            for (var f, g = Ub.ext.type.order[c.sType + "-pre"], h = 0, i = a.aoData.length; h < i; h++) if (c = a.aoData[h], 
            c._aSortData || (c._aSortData = []), !c._aSortData[b] || d) f = d ? e[h] : w(a, h, b, "sort"), 
            c._aSortData[b] = g ? g(f) : f;
        }
        function Fb(a) {
            if (a.oFeatures.bStateSave && !a.bDestroying) {
                var b = {
                    time: +new Date(),
                    start: a._iDisplayStart,
                    length: a._iDisplayLength,
                    order: d.extend(!0, [], a.aaSorting),
                    search: ab(a.oPreviousSearch),
                    columns: d.map(a.aoColumns, function(b, c) {
                        return {
                            visible: b.bVisible,
                            search: ab(a.aoPreSearchCols[c])
                        };
                    })
                };
                Nb(a, "aoStateSaveParams", "stateSaveParams", [ a, b ]);
                a.oSavedState = b;
                a.fnStateSaveCallback.call(a.oInstance, a, b);
            }
        }
        function Gb(a) {
            var b, c, e = a.aoColumns;
            if (a.oFeatures.bStateSave) {
                var f = a.fnStateLoadCallback.call(a.oInstance, a);
                if (f && f.time && (b = Nb(a, "aoStateLoadParams", "stateLoadParams", [ a, f ]), 
                -1 === d.inArray(!1, b) && (b = a.iStateDuration, !(0 < b && f.time < +new Date() - 1e3 * b) && e.length === f.columns.length))) {
                    a.oLoadedState = d.extend(!0, {}, f);
                    a._iDisplayStart = f.start;
                    a.iInitDisplayStart = f.start;
                    a._iDisplayLength = f.length;
                    a.aaSorting = [];
                    d.each(f.order, function(b, c) {
                        a.aaSorting.push(c[0] >= e.length ? [ 0, c[1] ] : c);
                    });
                    d.extend(a.oPreviousSearch, bb(f.search));
                    b = 0;
                    for (c = f.columns.length; b < c; b++) {
                        var g = f.columns[b];
                        e[b].bVisible = g.visible;
                        d.extend(a.aoPreSearchCols[b], bb(g.search));
                    }
                    Nb(a, "aoStateLoaded", "stateLoaded", [ a, f ]);
                }
            }
        }
        function Hb(a) {
            var b = Ub.settings, a = d.inArray(a, jc(b, "nTable"));
            return -1 !== a ? b[a] : null;
        }
        function Ib(b, c, d, e) {
            d = "DataTables warning: " + (null !== b ? "table id=" + b.sTableId + " - " : "") + d;
            e && (d += ". For more information about this error, please see http://datatables.net/tn/" + e);
            if (c) a.console && console.log && console.log(d); else if (b = Ub.ext, "alert" == (b.sErrMode || b.errMode)) alert(d); else throw Error(d);
        }
        function Jb(a, b, e, f) {
            d.isArray(e) ? d.each(e, function(c, e) {
                d.isArray(e) ? Jb(a, b, e[0], e[1]) : Jb(a, b, e);
            }) : (f === c && (f = e), b[e] !== c && (a[f] = b[e]));
        }
        function Kb(a, b, c) {
            var e, f;
            for (f in b) b.hasOwnProperty(f) && (e = b[f], d.isPlainObject(e) ? (d.isPlainObject(a[f]) || (a[f] = {}), 
            d.extend(!0, a[f], e)) : a[f] = c && "data" !== f && "aaData" !== f && d.isArray(e) ? e.slice() : e);
            return a;
        }
        function Lb(a, b, c) {
            d(a).bind("click.DT", b, function(b) {
                a.blur();
                c(b);
            }).bind("keypress.DT", b, function(a) {
                13 === a.which && (a.preventDefault(), c(a));
            }).bind("selectstart.DT", function() {
                return !1;
            });
        }
        function Mb(a, b, c, d) {
            c && a[b].push({
                fn: c,
                sName: d
            });
        }
        function Nb(a, b, c, e) {
            var f = [];
            b && (f = d.map(a[b].slice().reverse(), function(b) {
                return b.fn.apply(a.oInstance, e);
            }));
            null !== c && d(a.nTable).trigger(c + ".dt", e);
            return f;
        }
        function Ob(a) {
            var b = a._iDisplayStart, c = a.fnDisplayEnd(), d = a._iDisplayLength;
            c === a.fnRecordsDisplay() && (b = c - d);
            if (-1 === d || 0 > b) b = 0;
            a._iDisplayStart = b;
        }
        function Pb(a, b) {
            var c = a.renderer, e = Ub.ext.renderer[b];
            return d.isPlainObject(c) && c[b] ? e[c[b]] || e._ : "string" === typeof c ? e[c] || e._ : e._;
        }
        function Qb(a) {
            return a.oFeatures.bServerSide ? "ssp" : a.ajax || a.sAjaxSource ? "ajax" : "dom";
        }
        function Rb(a, b) {
            var c = [], c = Ic.numbers_length, d = Math.floor(c / 2);
            b <= c ? c = lc(0, b) : a <= d ? (c = lc(0, c - 2), c.push("ellipsis"), c.push(b - 1)) : (a >= b - 1 - d ? c = lc(b - (c - 2), b) : (c = lc(a - 1, a + 2), 
            c.push("ellipsis"), c.push(b - 1)), c.splice(0, 0, "ellipsis"), c.splice(0, 0, 0));
            c.DT_el = "span";
            return c;
        }
        function Sb(a) {
            d.each({
                num: function(b) {
                    return Jc(b, a);
                },
                "num-fmt": function(b) {
                    return Jc(b, a, dc);
                },
                "html-num": function(b) {
                    return Jc(b, a, _b);
                },
                "html-num-fmt": function(b) {
                    return Jc(b, a, _b, dc);
                }
            }, function(b, c) {
                Vb.type.order[b + a + "-pre"] = c;
            });
        }
        function Tb(a) {
            return function() {
                var b = [ Hb(this[Ub.ext.iApiIndex]) ].concat(Array.prototype.slice.call(arguments));
                return Ub.ext.internal[a].apply(this, b);
            };
        }
        var Ub, Vb, Wb, Xb, Yb, Zb = {}, $b = /[\r\n]/g, _b = /<.*?>/g, ac = /^[\w\+\-]/, bc = /[\w\+\-]$/, cc = RegExp("(\\/|\\.|\\*|\\+|\\?|\\||\\(|\\)|\\[|\\]|\\{|\\}|\\\\|\\$|\\^|\\-)", "g"), dc = /[',$\u00a3\u20ac\u00a5%\u2009\u202F]/g, ec = function(a) {
            return !a || !0 === a || "-" === a ? !0 : !1;
        }, fc = function(a) {
            var b = parseInt(a, 10);
            return !isNaN(b) && isFinite(a) ? b : null;
        }, gc = function(a, b) {
            Zb[b] || (Zb[b] = RegExp($(b), "g"));
            return "string" === typeof a ? a.replace(/\./g, "").replace(Zb[b], ".") : a;
        }, hc = function(a, b, c) {
            var d = "string" === typeof a;
            b && d && (a = gc(a, b));
            c && d && (a = a.replace(dc, ""));
            return ec(a) || !isNaN(parseFloat(a)) && isFinite(a);
        }, ic = function(a, b, c) {
            return ec(a) ? !0 : !(ec(a) || "string" === typeof a) ? null : hc(a.replace(_b, ""), b, c) ? !0 : null;
        }, jc = function(a, b, d) {
            var e = [], f = 0, g = a.length;
            if (d !== c) for (;f < g; f++) a[f] && a[f][b] && e.push(a[f][b][d]); else for (;f < g; f++) a[f] && e.push(a[f][b]);
            return e;
        }, kc = function(a, b, d, e) {
            var f = [], g = 0, h = b.length;
            if (e !== c) for (;g < h; g++) f.push(a[b[g]][d][e]); else for (;g < h; g++) f.push(a[b[g]][d]);
            return f;
        }, lc = function(a, b) {
            var d = [], e;
            b === c ? (b = 0, e = a) : (e = b, b = a);
            for (var f = b; f < e; f++) d.push(f);
            return d;
        }, mc = function(a) {
            var b = [], c, d, e = a.length, f, g = 0;
            d = 0;
            a: for (;d < e; d++) {
                c = a[d];
                for (f = 0; f < g; f++) if (b[f] === c) continue a;
                b.push(c);
                g++;
            }
            return b;
        }, nc = function(a, b, d) {
            a[b] !== c && (a[d] = a[b]);
        }, oc = /\[.*?\]$/, pc = /\(\)$/, qc = d("<div>")[0], rc = qc.textContent !== c, sc = /<.*?>/g;
        Ub = function(a) {
            this.$ = function(a, b) {
                return this.api(!0).$(a, b);
            };
            this._ = function(a, b) {
                return this.api(!0).rows(a, b).data();
            };
            this.api = function(a) {
                return a ? new Wb(Hb(this[Vb.iApiIndex])) : new Wb(this);
            };
            this.fnAddData = function(a, b) {
                var e = this.api(!0), f = d.isArray(a) && (d.isArray(a[0]) || d.isPlainObject(a[0])) ? e.rows.add(a) : e.row.add(a);
                (b === c || b) && e.draw();
                return f.flatten().toArray();
            };
            this.fnAdjustColumnSizing = function(a) {
                var b = this.api(!0).columns.adjust(), d = b.settings()[0], e = d.oScroll;
                a === c || a ? b.draw(!1) : ("" !== e.sX || "" !== e.sY) && ob(d);
            };
            this.fnClearTable = function(a) {
                var b = this.api(!0).clear();
                (a === c || a) && b.draw();
            };
            this.fnClose = function(a) {
                this.api(!0).row(a).child.hide();
            };
            this.fnDeleteRow = function(a, b, d) {
                var e = this.api(!0), a = e.rows(a), f = a.settings()[0], g = f.aoData[a[0][0]];
                a.remove();
                b && b.call(this, f, g);
                (d === c || d) && e.draw();
                return g;
            };
            this.fnDestroy = function(a) {
                this.api(!0).destroy(a);
            };
            this.fnDraw = function(a) {
                this.api(!0).draw(!a);
            };
            this.fnFilter = function(a, b, d, e, f, g) {
                f = this.api(!0);
                null === b || b === c ? f.search(a, d, e, g) : f.column(b).search(a, d, e, g);
                f.draw();
            };
            this.fnGetData = function(a, b) {
                var d = this.api(!0);
                if (a !== c) {
                    var e = a.nodeName ? a.nodeName.toLowerCase() : "";
                    return b !== c || "td" == e || "th" == e ? d.cell(a, b).data() : d.row(a).data() || null;
                }
                return d.data().toArray();
            };
            this.fnGetNodes = function(a) {
                var b = this.api(!0);
                return a !== c ? b.row(a).node() : b.rows().nodes().flatten().toArray();
            };
            this.fnGetPosition = function(a) {
                var b = this.api(!0), c = a.nodeName.toUpperCase();
                return "TR" == c ? b.row(a).index() : "TD" == c || "TH" == c ? (a = b.cell(a).index(), 
                [ a.row, a.columnVisible, a.column ]) : null;
            };
            this.fnIsOpen = function(a) {
                return this.api(!0).row(a).child.isShown();
            };
            this.fnOpen = function(a, b, c) {
                return this.api(!0).row(a).child(b, c).show().child()[0];
            };
            this.fnPageChange = function(a, b) {
                var d = this.api(!0).page(a);
                (b === c || b) && d.draw(!1);
            };
            this.fnSetColumnVis = function(a, b, d) {
                a = this.api(!0).column(a).visible(b);
                (d === c || d) && a.columns.adjust().draw();
            };
            this.fnSettings = function() {
                return Hb(this[Vb.iApiIndex]);
            };
            this.fnSort = function(a) {
                this.api(!0).order(a).draw();
            };
            this.fnSortListener = function(a, b, c) {
                this.api(!0).order.listener(a, b, c);
            };
            this.fnUpdate = function(a, b, d, e, f) {
                var g = this.api(!0);
                d === c || null === d ? g.row(b).data(a) : g.cell(b, d).data(a);
                (f === c || f) && g.columns.adjust();
                (e === c || e) && g.draw();
                return 0;
            };
            this.fnVersionCheck = Vb.fnVersionCheck;
            var b = this, e = a === c, k = this.length;
            e && (a = {});
            this.oApi = this.internal = Vb.internal;
            for (var n in Ub.ext.internal) n && (this[n] = Tb(n));
            this.each(function() {
                var n = {}, o = 1 < k ? Kb(n, a, !0) : a, p = 0, q, r = this.getAttribute("id"), n = !1, s = Ub.defaults;
                if ("table" != this.nodeName.toLowerCase()) Ib(null, 0, "Non-table node initialisation (" + this.nodeName + ")", 2); else {
                    h(s);
                    i(s.column);
                    f(s, s, !0);
                    f(s.column, s.column, !0);
                    f(s, o);
                    var w = Ub.settings, p = 0;
                    for (q = w.length; p < q; p++) {
                        if (w[p].nTable == this) {
                            q = o.bRetrieve !== c ? o.bRetrieve : s.bRetrieve;
                            if (e || q) return w[p].oInstance;
                            if (o.bDestroy !== c ? o.bDestroy : s.bDestroy) {
                                w[p].oInstance.fnDestroy();
                                break;
                            } else {
                                Ib(w[p], 0, "Cannot reinitialise DataTable", 3);
                                return;
                            }
                        }
                        if (w[p].sTableId == this.id) {
                            w.splice(p, 1);
                            break;
                        }
                    }
                    if (null === r || "" === r) this.id = r = "DataTables_Table_" + Ub.ext._unique++;
                    var x = d.extend(!0, {}, Ub.models.oSettings, {
                        nTable: this,
                        oApi: b.internal,
                        oInit: o,
                        sDestroyWidth: d(this)[0].style.width,
                        sInstance: r,
                        sTableId: r
                    });
                    w.push(x);
                    x.oInstance = 1 === b.length ? b : d(this).dataTable();
                    h(o);
                    o.oLanguage && g(o.oLanguage);
                    o.aLengthMenu && !o.iDisplayLength && (o.iDisplayLength = d.isArray(o.aLengthMenu[0]) ? o.aLengthMenu[0][0] : o.aLengthMenu[0]);
                    o = Kb(d.extend(!0, {}, s), o);
                    Jb(x.oFeatures, o, "bPaginate bLengthChange bFilter bSort bSortMulti bInfo bProcessing bAutoWidth bSortClasses bServerSide bDeferRender".split(" "));
                    Jb(x, o, [ "asStripeClasses", "ajax", "fnServerData", "fnFormatNumber", "sServerMethod", "aaSorting", "aaSortingFixed", "aLengthMenu", "sPaginationType", "sAjaxSource", "sAjaxDataProp", "iStateDuration", "sDom", "bSortCellsTop", "iTabIndex", "fnStateLoadCallback", "fnStateSaveCallback", "renderer", [ "iCookieDuration", "iStateDuration" ], [ "oSearch", "oPreviousSearch" ], [ "aoSearchCols", "aoPreSearchCols" ], [ "iDisplayLength", "_iDisplayLength" ], [ "bJQueryUI", "bJUI" ] ]);
                    Jb(x.oScroll, o, [ [ "sScrollX", "sX" ], [ "sScrollXInner", "sXInner" ], [ "sScrollY", "sY" ], [ "bScrollCollapse", "bCollapse" ] ]);
                    Jb(x.oLanguage, o, "fnInfoCallback");
                    Mb(x, "aoDrawCallback", o.fnDrawCallback, "user");
                    Mb(x, "aoServerParams", o.fnServerParams, "user");
                    Mb(x, "aoStateSaveParams", o.fnStateSaveParams, "user");
                    Mb(x, "aoStateLoadParams", o.fnStateLoadParams, "user");
                    Mb(x, "aoStateLoaded", o.fnStateLoaded, "user");
                    Mb(x, "aoRowCallback", o.fnRowCallback, "user");
                    Mb(x, "aoRowCreatedCallback", o.fnCreatedRow, "user");
                    Mb(x, "aoHeaderCallback", o.fnHeaderCallback, "user");
                    Mb(x, "aoFooterCallback", o.fnFooterCallback, "user");
                    Mb(x, "aoInitComplete", o.fnInitComplete, "user");
                    Mb(x, "aoPreDrawCallback", o.fnPreDrawCallback, "user");
                    r = x.oClasses;
                    o.bJQueryUI ? (d.extend(r, Ub.ext.oJUIClasses, o.oClasses), o.sDom === s.sDom && "lfrtip" === s.sDom && (x.sDom = '<"H"lfr>t<"F"ip>'), 
                    x.renderer) ? d.isPlainObject(x.renderer) && !x.renderer.header && (x.renderer.header = "jqueryui") : x.renderer = "jqueryui" : d.extend(r, Ub.ext.classes, o.oClasses);
                    d(this).addClass(r.sTable);
                    if ("" !== x.oScroll.sX || "" !== x.oScroll.sY) x.oScroll.iBarWidth = xb();
                    !0 === x.oScroll.sX && (x.oScroll.sX = "100%");
                    x.iInitDisplayStart === c && (x.iInitDisplayStart = o.iDisplayStart, x._iDisplayStart = o.iDisplayStart);
                    null !== o.iDeferLoading && (x.bDeferLoading = !0, p = d.isArray(o.iDeferLoading), 
                    x._iRecordsDisplay = p ? o.iDeferLoading[0] : o.iDeferLoading, x._iRecordsTotal = p ? o.iDeferLoading[1] : o.iDeferLoading);
                    "" !== o.oLanguage.sUrl ? (x.oLanguage.sUrl = o.oLanguage.sUrl, d.getJSON(x.oLanguage.sUrl, null, function(a) {
                        g(a);
                        f(s.oLanguage, a);
                        d.extend(true, x.oLanguage, o.oLanguage, a);
                        fb(x);
                    }), n = !0) : d.extend(!0, x.oLanguage, o.oLanguage);
                    null === o.asStripeClasses && (x.asStripeClasses = [ r.sStripeOdd, r.sStripeEven ]);
                    var p = x.asStripeClasses, y = d("tbody tr:eq(0)", this);
                    -1 !== d.inArray(!0, d.map(p, function(a) {
                        return y.hasClass(a);
                    })) && (d("tbody tr", this).removeClass(p.join(" ")), x.asDestroyStripes = p.slice());
                    var w = [], z, p = this.getElementsByTagName("thead");
                    0 !== p.length && (N(x.aoHeader, p[0]), w = O(x));
                    if (null === o.aoColumns) {
                        z = [];
                        p = 0;
                        for (q = w.length; p < q; p++) z.push(null);
                    } else z = o.aoColumns;
                    p = 0;
                    for (q = z.length; p < q; p++) l(x, w ? w[p] : null);
                    t(x, o.aoColumnDefs, z, function(a, b) {
                        m(x, a, b);
                    });
                    if (y.length) {
                        var A = function(a, b) {
                            return a.getAttribute("data-" + b) ? b : null;
                        };
                        d.each(F(x, y[0]).cells, function(a, b) {
                            var d = x.aoColumns[a];
                            if (d.mData === a) {
                                var e = A(b, "sort") || A(b, "order"), f = A(b, "filter") || A(b, "search");
                                if (null !== e || null !== f) {
                                    d.mData = {
                                        _: a + ".display",
                                        sort: null !== e ? a + ".@data-" + e : c,
                                        type: null !== e ? a + ".@data-" + e : c,
                                        filter: null !== f ? a + ".@data-" + f : c
                                    };
                                    m(x, a);
                                }
                            }
                        });
                    }
                    var B = x.oFeatures;
                    o.bStateSave && (B.bStateSave = !0, Gb(x, o), Mb(x, "aoDrawCallback", Fb, "state_save"));
                    if (o.aaSorting === c) {
                        w = x.aaSorting;
                        p = 0;
                        for (q = w.length; p < q; p++) w[p][1] = x.aoColumns[p].asSorting[0];
                    }
                    Db(x);
                    B.bSort && Mb(x, "aoDrawCallback", function() {
                        if (x.bSorted) {
                            var a = yb(x), b = {};
                            d.each(a, function(a, c) {
                                b[c.src] = c.dir;
                            });
                            Nb(x, null, "order", [ x, a, b ]);
                            Ab(x);
                        }
                    });
                    Mb(x, "aoDrawCallback", function() {
                        (x.bSorted || "ssp" === Qb(x) || B.bDeferRender) && Db(x);
                    }, "sc");
                    j(x);
                    p = d(this).children("caption").each(function() {
                        this._captionSide = d(this).css("caption-side");
                    });
                    q = d(this).children("thead");
                    0 === q.length && (q = d("<thead/>").appendTo(this));
                    x.nTHead = q[0];
                    q = d(this).children("tbody");
                    0 === q.length && (q = d("<tbody/>").appendTo(this));
                    x.nTBody = q[0];
                    q = d(this).children("tfoot");
                    if (0 === q.length && 0 < p.length && ("" !== x.oScroll.sX || "" !== x.oScroll.sY)) q = d("<tfoot/>").appendTo(this);
                    0 === q.length || 0 === q.children().length ? d(this).addClass(r.sNoFooter) : 0 < q.length && (x.nTFoot = q[0], 
                    N(x.aoFooter, x.nTFoot));
                    if (o.aaData) for (p = 0; p < o.aaData.length; p++) u(x, o.aaData[p]); else (x.bDeferLoading || "dom" == Qb(x)) && v(x, d(x.nTBody).children("tr"));
                    x.aiDisplay = x.aiDisplayMaster.slice();
                    x.bInitialised = !0;
                    !1 === n && fb(x);
                }
            });
            b = null;
            return this;
        };
        var tc = [], uc = Array.prototype, vc = function(a) {
            var b, c, e = Ub.settings, f = d.map(e, function(a) {
                return a.nTable;
            });
            if (a) {
                if (a.nTable && a.oApi) return [ a ];
                if (a.nodeName && "table" === a.nodeName.toLowerCase()) return b = d.inArray(a, f), 
                -1 !== b ? [ e[b] ] : null;
                if (a && "function" === typeof a.settings) return a.settings().toArray();
                "string" === typeof a ? c = d(a) : a instanceof d && (c = a);
            } else return [];
            if (c) return c.map(function() {
                b = d.inArray(this, f);
                return -1 !== b ? e[b] : null;
            }).toArray();
        };
        Wb = function(a, b) {
            if (!this instanceof Wb) throw "DT API must be constructed as a new object";
            var c = [], e = function(a) {
                (a = vc(a)) && c.push.apply(c, a);
            };
            if (d.isArray(a)) for (var f = 0, g = a.length; f < g; f++) e(a[f]); else e(a);
            this.context = mc(c);
            b && this.push.apply(this, b.toArray ? b.toArray() : b);
            this.selector = {
                rows: null,
                cols: null,
                opts: null
            };
            Wb.extend(this, this, tc);
        };
        Ub.Api = Wb;
        Wb.prototype = {
            concat: uc.concat,
            context: [],
            each: function(a) {
                for (var b = 0, c = this.length; b < c; b++) a.call(this, this[b], b, this);
                return this;
            },
            eq: function(a) {
                var b = this.context;
                return b.length > a ? new Wb(b[a], this[a]) : null;
            },
            filter: function(a) {
                var b = [];
                if (uc.filter) b = uc.filter.call(this, a, this); else for (var c = 0, d = this.length; c < d; c++) a.call(this, this[c], c, this) && b.push(this[c]);
                return new Wb(this.context, b);
            },
            flatten: function() {
                var a = [];
                return new Wb(this.context, a.concat.apply(a, this.toArray()));
            },
            join: uc.join,
            indexOf: uc.indexOf || function(a, b) {
                for (var c = b || 0, d = this.length; c < d; c++) if (this[c] === a) return c;
                return -1;
            },
            iterator: function(a, b, d) {
                var e = [], f, g, h, i, j, k = this.context, l, m, n = this.selector;
                "string" === typeof a && (d = b, b = a, a = !1);
                g = 0;
                for (h = k.length; g < h; g++) if ("table" === b) f = d(k[g], g), f !== c && e.push(f); else if ("columns" === b || "rows" === b) f = d(k[g], this[g], g), 
                f !== c && e.push(f); else if ("column" === b || "column-rows" === b || "row" === b || "cell" === b) {
                    m = this[g];
                    "column-rows" === b && (l = Ac(k[g], n.opts));
                    i = 0;
                    for (j = m.length; i < j; i++) f = m[i], f = "cell" === b ? d(k[g], f.row, f.column, g, i) : d(k[g], f, g, i, l), 
                    f !== c && e.push(f);
                }
                return e.length ? (a = new Wb(k, a ? e.concat.apply([], e) : e), b = a.selector, 
                b.rows = n.rows, b.cols = n.cols, b.opts = n.opts, a) : this;
            },
            lastIndexOf: uc.lastIndexOf || function(a, b) {
                return this.indexOf.apply(this.toArray.reverse(), arguments);
            },
            length: 0,
            map: function(a) {
                var b = [];
                if (uc.map) b = uc.map.call(this, a, this); else for (var c = 0, d = this.length; c < d; c++) b.push(a.call(this, this[c], c));
                return new Wb(this.context, b);
            },
            pluck: function(a) {
                return this.map(function(b) {
                    return b[a];
                });
            },
            pop: uc.pop,
            push: uc.push,
            reduce: uc.reduce || function(a, b) {
                return k(this, a, b, 0, this.length, 1);
            },
            reduceRight: uc.reduceRight || function(a, b) {
                return k(this, a, b, this.length - 1, -1, -1);
            },
            reverse: uc.reverse,
            selector: null,
            shift: uc.shift,
            sort: uc.sort,
            splice: uc.splice,
            toArray: function() {
                return uc.slice.call(this);
            },
            to$: function() {
                return d(this);
            },
            toJQuery: function() {
                return d(this);
            },
            unique: function() {
                return new Wb(this.context, mc(this));
            },
            unshift: uc.unshift
        };
        Wb.extend = function(a, b, c) {
            if (b && (b instanceof Wb || b.__dt_wrapper)) {
                var e, f, g, h = function(a, b, c) {
                    return function() {
                        var d = b.apply(a, arguments);
                        Wb.extend(d, d, c.methodExt);
                        return d;
                    };
                };
                e = 0;
                for (f = c.length; e < f; e++) g = c[e], b[g.name] = "function" === typeof g.val ? h(a, g.val, g) : d.isPlainObject(g.val) ? {} : g.val, 
                b[g.name].__dt_wrapper = !0, Wb.extend(a, b[g.name], g.propExt);
            }
        };
        Wb.register = Xb = function(a, b) {
            if (d.isArray(a)) for (var c = 0, e = a.length; c < e; c++) Wb.register(a[c], b); else for (var f = a.split("."), g = tc, h, i, c = 0, e = f.length; c < e; c++) {
                h = (i = -1 !== f[c].indexOf("()")) ? f[c].replace("()", "") : f[c];
                var j;
                a: {
                    j = 0;
                    for (var k = g.length; j < k; j++) if (g[j].name === h) {
                        j = g[j];
                        break a;
                    }
                    j = null;
                }
                j || (j = {
                    name: h,
                    val: {},
                    methodExt: [],
                    propExt: []
                }, g.push(j));
                c === e - 1 ? j.val = b : g = i ? j.methodExt : j.propExt;
            }
        };
        Wb.registerPlural = Yb = function(a, b, e) {
            Wb.register(a, e);
            Wb.register(b, function() {
                var a = e.apply(this, arguments);
                return a === this ? this : a instanceof Wb ? a.length ? d.isArray(a[0]) ? new Wb(a.context, a[0]) : a[0] : c : a;
            });
        };
        Xb("tables()", function(a) {
            var b;
            if (a) {
                b = Wb;
                var c = this.context;
                if ("number" === typeof a) a = [ c[a] ]; else var e = d.map(c, function(a) {
                    return a.nTable;
                }), a = d(e).filter(a).map(function() {
                    var a = d.inArray(this, e);
                    return c[a];
                }).toArray();
                b = new b(a);
            } else b = this;
            return b;
        });
        Xb("table()", function(a) {
            var a = this.tables(a), b = a.context;
            return b.length ? new Wb(b[0]) : a;
        });
        Yb("tables().nodes()", "table().node()", function() {
            return this.iterator("table", function(a) {
                return a.nTable;
            });
        });
        Yb("tables().body()", "table().body()", function() {
            return this.iterator("table", function(a) {
                return a.nTBody;
            });
        });
        Yb("tables().header()", "table().header()", function() {
            return this.iterator("table", function(a) {
                return a.nTHead;
            });
        });
        Yb("tables().footer()", "table().footer()", function() {
            return this.iterator("table", function(a) {
                return a.nTFoot;
            });
        });
        Yb("tables().containers()", "table().container()", function() {
            return this.iterator("table", function(a) {
                return a.nTableWrapper;
            });
        });
        Xb("draw()", function(a) {
            return this.iterator("table", function(b) {
                L(b, !1 === a);
            });
        });
        Xb("page()", function(a) {
            return a === c ? this.page.info().page : this.iterator("table", function(b) {
                kb(b, a);
            });
        });
        Xb("page.info()", function() {
            if (0 === this.context.length) return c;
            var a = this.context[0], b = a._iDisplayStart, d = a._iDisplayLength, e = a.fnRecordsDisplay(), f = -1 === d;
            return {
                page: f ? 0 : Math.floor(b / d),
                pages: f ? 1 : Math.ceil(e / d),
                start: b,
                end: a.fnDisplayEnd(),
                length: d,
                recordsTotal: a.fnRecordsTotal(),
                recordsDisplay: e
            };
        });
        Xb("page.len()", function(a) {
            return a === c ? 0 !== this.context.length ? this.context[0]._iDisplayLength : c : this.iterator("table", function(b) {
                hb(b, a);
            });
        });
        var wc = function(a, b, c) {
            "ssp" == Qb(a) ? L(a, b) : (mb(a, !0), P(a, [], function(c) {
                C(a);
                for (var c = T(a, c), d = 0, e = c.length; d < e; d++) u(a, c[d]);
                L(a, b);
                mb(a, !1);
            }));
            if (c) {
                var d = new Wb(a);
                d.one("draw", function() {
                    c(d.ajax.json());
                });
            }
        };
        Xb("ajax.json()", function() {
            var a = this.context;
            if (0 < a.length) return a[0].json;
        });
        Xb("ajax.params()", function() {
            var a = this.context;
            if (0 < a.length) return a[0].oAjaxData;
        });
        Xb("ajax.reload()", function(a, b) {
            return this.iterator("table", function(c) {
                wc(c, !1 === b, a);
            });
        });
        Xb("ajax.url()", function(a) {
            var b = this.context;
            if (a === c) {
                if (0 === b.length) return c;
                b = b[0];
                return b.ajax ? d.isPlainObject(b.ajax) ? b.ajax.url : b.ajax : b.sAjaxSource;
            }
            return this.iterator("table", function(b) {
                d.isPlainObject(b.ajax) ? b.ajax.url = a : b.ajax = a;
            });
        });
        Xb("ajax.url().load()", function(a, b) {
            return this.iterator("table", function(c) {
                wc(c, !1 === b, a);
            });
        });
        var xc = function(a, b) {
            var e = [], f, g, h, i, j, k;
            if (!a || "string" === typeof a || a.length === c) a = [ a ];
            h = 0;
            for (i = a.length; h < i; h++) {
                g = a[h] && a[h].split ? a[h].split(",") : [ a[h] ];
                j = 0;
                for (k = g.length; j < k; j++) (f = b("string" === typeof g[j] ? d.trim(g[j]) : g[j])) && f.length && e.push.apply(e, f);
            }
            return e;
        }, yc = function(a) {
            a || (a = {});
            a.filter && !a.search && (a.search = a.filter);
            return {
                search: a.search || "none",
                order: a.order || "current",
                page: a.page || "all"
            };
        }, zc = function(a) {
            for (var b = 0, c = a.length; b < c; b++) if (0 < a[b].length) return a[0] = a[b], 
            a.length = 1, a.context = [ a.context[b] ], a;
            a.length = 0;
            return a;
        }, Ac = function(a, b) {
            var c, e, f, g = [], h = a.aiDisplay;
            c = a.aiDisplayMaster;
            var i = b.search;
            e = b.order;
            f = b.page;
            if ("ssp" == Qb(a)) return "removed" === i ? [] : lc(0, c.length);
            if ("current" == f) {
                c = a._iDisplayStart;
                for (e = a.fnDisplayEnd(); c < e; c++) g.push(h[c]);
            } else if ("current" == e || "applied" == e) g = "none" == i ? c.slice() : "applied" == i ? h.slice() : d.map(c, function(a) {
                return -1 === d.inArray(a, h) ? a : null;
            }); else if ("index" == e || "original" == e) {
                c = 0;
                for (e = a.aoData.length; c < e; c++) "none" == i ? g.push(c) : (f = d.inArray(c, h), 
                (-1 === f && "removed" == i || 0 <= f && "applied" == i) && g.push(c));
            }
            return g;
        };
        Xb("rows()", function(a, b) {
            a === c ? a = "" : d.isPlainObject(a) && (b = a, a = "");
            var b = yc(b), e = this.iterator("table", function(c) {
                var e = b;
                return xc(a, function(a) {
                    var b = fc(a);
                    if (null !== b && !e) return [ b ];
                    var f = Ac(c, e);
                    if (null !== b && d.inArray(b, f) !== -1) return [ b ];
                    if (!a) return f;
                    for (var b = [], g = 0, h = f.length; g < h; g++) b.push(c.aoData[f[g]].nTr);
                    return a.nodeName && d.inArray(a, b) !== -1 ? [ a._DT_RowIndex ] : d(b).filter(a).map(function() {
                        return this._DT_RowIndex;
                    }).toArray();
                });
            });
            e.selector.rows = a;
            e.selector.opts = b;
            return e;
        });
        Xb("rows().nodes()", function() {
            return this.iterator("row", function(a, b) {
                return a.aoData[b].nTr || c;
            });
        });
        Xb("rows().data()", function() {
            return this.iterator(!0, "rows", function(a, b) {
                return kc(a.aoData, b, "_aData");
            });
        });
        Yb("rows().cache()", "row().cache()", function(a) {
            return this.iterator("row", function(b, c) {
                var d = b.aoData[c];
                return "search" === a ? d._aFilterData : d._aSortData;
            });
        });
        Yb("rows().invalidate()", "row().invalidate()", function(a) {
            return this.iterator("row", function(b, c) {
                E(b, c, a);
            });
        });
        Yb("rows().indexes()", "row().index()", function() {
            return this.iterator("row", function(a, b) {
                return b;
            });
        });
        Yb("rows().remove()", "row().remove()", function() {
            var a = this;
            return this.iterator("row", function(b, c, e) {
                var f = b.aoData;
                f.splice(c, 1);
                for (var g = 0, h = f.length; g < h; g++) null !== f[g].nTr && (f[g].nTr._DT_RowIndex = g);
                d.inArray(c, b.aiDisplay);
                D(b.aiDisplayMaster, c);
                D(b.aiDisplay, c);
                D(a[e], c, !1);
                Ob(b);
            });
        });
        Xb("rows.add()", function(a) {
            var b = this.iterator("table", function(b) {
                var c, d, e, f = [];
                d = 0;
                for (e = a.length; d < e; d++) c = a[d], c.nodeName && "TR" === c.nodeName.toUpperCase() ? f.push(v(b, c)[0]) : f.push(u(b, c));
                return f;
            }), c = this.rows(-1);
            c.pop();
            c.push.apply(c, b.toArray());
            return c;
        });
        Xb("row()", function(a, b) {
            return zc(this.rows(a, b));
        });
        Xb("row().data()", function(a) {
            var b = this.context;
            if (a === c) return b.length && this.length ? b[0].aoData[this[0]]._aData : c;
            b[0].aoData[this[0]]._aData = a;
            E(b[0], this[0], "data");
            return this;
        });
        Xb("row().node()", function() {
            var a = this.context;
            return a.length && this.length ? a[0].aoData[this[0]].nTr || null : null;
        });
        Xb("row.add()", function(a) {
            a instanceof d && a.length && (a = a[0]);
            var b = this.iterator("table", function(b) {
                return a.nodeName && "TR" === a.nodeName.toUpperCase() ? v(b, a)[0] : u(b, a);
            });
            return this.row(b[0]);
        });
        var Bc = function(a) {
            var b = a.context;
            b.length && a.length && (a = b[0].aoData[a[0]], a._details && (a._details.remove(), 
            a._detailsShow = c, a._details = c));
        }, Cc = function(a, b) {
            var c = a.context;
            if (c.length && a.length) {
                var d = c[0].aoData[a[0]];
                if (d._details) {
                    (d._detailsShow = b) ? d._details.insertAfter(d.nTr) : d._details.detach();
                    var e = c[0], f = new Wb(e), g = e.aoData;
                    f.off("draw.dt.DT_details column-visibility.dt.DT_details destroy.dt.DT_details");
                    0 < jc(g, "_details").length && (f.on("draw.dt.DT_details", function(a, b) {
                        e === b && f.rows({
                            page: "current"
                        }).eq(0).each(function(a) {
                            a = g[a];
                            a._detailsShow && a._details.insertAfter(a.nTr);
                        });
                    }), f.on("column-visibility.dt.DT_details", function(a, b) {
                        if (e === b) for (var c, d = q(b), f = 0, h = g.length; f < h; f++) c = g[f], c._details && c._details.children("td[colspan]").attr("colspan", d);
                    }), f.on("destroy.dt.DT_details", function(a, b) {
                        if (e === b) for (var c = 0, d = g.length; c < d; c++) g[c]._details && Bc(g[c]);
                    }));
                }
            }
        };
        Xb("row().child()", function(a, b) {
            var e = this.context;
            if (a === c) return e.length && this.length ? e[0].aoData[this[0]]._details : c;
            if (!0 === a) this.child.show(); else if (!1 === a) Bc(this); else if (e.length && this.length) {
                var f = e[0], e = e[0].aoData[this[0]], g = [], h = function(a, b) {
                    if (a.nodeName && "tr" === a.nodeName.toLowerCase()) g.push(a); else {
                        var c = d("<tr><td/></tr>").addClass(b);
                        d("td", c).addClass(b).html(a)[0].colSpan = q(f);
                        g.push(c[0]);
                    }
                };
                if (d.isArray(a) || a instanceof d) for (var i = 0, j = a.length; i < j; i++) h(a[i], b); else h(a, b);
                e._details && e._details.remove();
                e._details = d(g);
                e._detailsShow && e._details.insertAfter(e.nTr);
            }
            return this;
        });
        Xb([ "row().child.show()", "row().child().show()" ], function() {
            Cc(this, !0);
            return this;
        });
        Xb([ "row().child.hide()", "row().child().hide()" ], function() {
            Cc(this, !1);
            return this;
        });
        Xb([ "row().child.remove()", "row().child().remove()" ], function() {
            Bc(this);
            return this;
        });
        Xb("row().child.isShown()", function() {
            var a = this.context;
            return a.length && this.length ? a[0].aoData[this[0]]._detailsShow || !1 : !1;
        });
        var Dc = /^(.+):(name|visIdx|visible)$/;
        Xb("columns()", function(a, b) {
            a === c ? a = "" : d.isPlainObject(a) && (b = a, a = "");
            var b = yc(b), e = this.iterator("table", function(b) {
                var c = a, e = b.aoColumns, f = jc(e, "sName"), g = jc(e, "nTh");
                return xc(c, function(a) {
                    var c = fc(a);
                    if ("" === a) return lc(e.length);
                    if (null !== c) return [ c >= 0 ? c : e.length + c ];
                    var h = "string" === typeof a ? a.match(Dc) : "";
                    if (h) switch (h[2]) {
                      case "visIdx":
                      case "visible":
                        a = parseInt(h[1], 10);
                        if (a < 0) {
                            c = d.map(e, function(a, b) {
                                return a.bVisible ? b : null;
                            });
                            return [ c[c.length + a] ];
                        }
                        return [ o(b, a) ];

                      case "name":
                        return d.map(f, function(a, b) {
                            return a === h[1] ? b : null;
                        });
                    } else return d(g).filter(a).map(function() {
                        return d.inArray(this, g);
                    }).toArray();
                });
            });
            e.selector.cols = a;
            e.selector.opts = b;
            return e;
        });
        Yb("columns().header()", "column().header()", function() {
            return this.iterator("column", function(a, b) {
                return a.aoColumns[b].nTh;
            });
        });
        Yb("columns().footer()", "column().footer()", function() {
            return this.iterator("column", function(a, b) {
                return a.aoColumns[b].nTf;
            });
        });
        Yb("columns().data()", "column().data()", function() {
            return this.iterator("column-rows", function(a, b, c, d, e) {
                for (var c = [], d = 0, f = e.length; d < f; d++) c.push(w(a, e[d], b, ""));
                return c;
            });
        });
        Yb("columns().cache()", "column().cache()", function(a) {
            return this.iterator("column-rows", function(b, c, d, e, f) {
                return kc(b.aoData, f, "search" === a ? "_aFilterData" : "_aSortData", c);
            });
        });
        Yb("columns().nodes()", "column().nodes()", function() {
            return this.iterator("column-rows", function(a, b, c, d, e) {
                return kc(a.aoData, e, "anCells", b);
            });
        });
        Yb("columns().visible()", "column().visible()", function(a, b) {
            return this.iterator("column", function(e, f) {
                var g;
                if (a === c) g = e.aoColumns[f].bVisible; else {
                    var h = e.aoColumns;
                    g = h[f];
                    var i = e.aoData, j, k, l;
                    if (a === c) g = g.bVisible; else {
                        if (g.bVisible !== a) {
                            if (a) {
                                var m = d.inArray(!0, jc(h, "bVisible"), f + 1);
                                j = 0;
                                for (k = i.length; j < k; j++) l = i[j].nTr, h = i[j].anCells, l && l.insertBefore(h[f], h[m] || null);
                            } else d(jc(e.aoData, "anCells", f)).detach();
                            g.bVisible = a;
                            J(e, e.aoHeader);
                            J(e, e.aoFooter);
                            if (b === c || b) n(e), (e.oScroll.sX || e.oScroll.sY) && ob(e);
                            Nb(e, null, "column-visibility", [ e, f, a ]);
                            Fb(e);
                        }
                        g = void 0;
                    }
                }
                return g;
            });
        });
        Yb("columns().indexes()", "column().index()", function(a) {
            return this.iterator("column", function(b, c) {
                return "visible" === a ? p(b, c) : c;
            });
        });
        Xb("columns.adjust()", function() {
            return this.iterator("table", function(a) {
                n(a);
            });
        });
        Xb("column.index()", function(a, b) {
            if (0 !== this.context.length) {
                var c = this.context[0];
                if ("fromVisible" === a || "toData" === a) return o(c, b);
                if ("fromData" === a || "toVisible" === a) return p(c, b);
            }
        });
        Xb("column()", function(a, b) {
            return zc(this.columns(a, b));
        });
        Xb("cells()", function(a, b, e) {
            d.isPlainObject(a) && (typeof a.row !== c ? (e = b, b = null) : (e = a, a = null));
            d.isPlainObject(b) && (e = b, b = null);
            if (null === b || b === c) return this.iterator("table", function(b) {
                var f = a, g = yc(e), h = b.aoData, i = Ac(b, g), g = kc(h, i, "anCells"), j = d([].concat.apply([], g)), k, l = b.aoColumns.length, m, n, o, p;
                return xc(f, function(a) {
                    if (null === a || a === c) {
                        m = [];
                        n = 0;
                        for (o = i.length; n < o; n++) {
                            k = i[n];
                            for (p = 0; p < l; p++) m.push({
                                row: k,
                                column: p
                            });
                        }
                        return m;
                    }
                    return d.isPlainObject(a) ? [ a ] : j.filter(a).map(function(a, b) {
                        k = b.parentNode._DT_RowIndex;
                        return {
                            row: k,
                            column: d.inArray(b, h[k].anCells)
                        };
                    }).toArray();
                });
            });
            var f = this.columns(b, e), g = this.rows(a, e), h, i, j, k, l, m = this.iterator("table", function(a, b) {
                h = [];
                i = 0;
                for (j = g[b].length; i < j; i++) {
                    k = 0;
                    for (l = f[b].length; k < l; k++) h.push({
                        row: g[b][i],
                        column: f[b][k]
                    });
                }
                return h;
            });
            d.extend(m.selector, {
                cols: b,
                rows: a,
                opts: e
            });
            return m;
        });
        Yb("cells().nodes()", "cell().node()", function() {
            return this.iterator("cell", function(a, b, c) {
                return a.aoData[b].anCells[c];
            });
        });
        Xb("cells().data()", function() {
            return this.iterator("cell", function(a, b, c) {
                return w(a, b, c);
            });
        });
        Yb("cells().cache()", "cell().cache()", function(a) {
            a = "search" === a ? "_aFilterData" : "_aSortData";
            return this.iterator("cell", function(b, c, d) {
                return b.aoData[c][a][d];
            });
        });
        Yb("cells().indexes()", "cell().index()", function() {
            return this.iterator("cell", function(a, b, c) {
                return {
                    row: b,
                    column: c,
                    columnVisible: p(a, c)
                };
            });
        });
        Xb([ "cells().invalidate()", "cell().invalidate()" ], function(a) {
            var b = this.selector;
            this.rows(b.rows, b.opts).invalidate(a);
            return this;
        });
        Xb("cell()", function(a, b, c) {
            return zc(this.cells(a, b, c));
        });
        Xb("cell().data()", function(a) {
            var b = this.context, d = this[0];
            if (a === c) return b.length && d.length ? w(b[0], d[0].row, d[0].column) : c;
            x(b[0], d[0].row, d[0].column, a);
            E(b[0], d[0].row, "data", d[0].column);
            return this;
        });
        Xb("order()", function(a, b) {
            var e = this.context;
            if (a === c) return 0 !== e.length ? e[0].aaSorting : c;
            "number" === typeof a ? a = [ [ a, b ] ] : d.isArray(a[0]) || (a = Array.prototype.slice.call(arguments));
            return this.iterator("table", function(b) {
                b.aaSorting = a.slice();
            });
        });
        Xb("order.listener()", function(a, b, c) {
            return this.iterator("table", function(d) {
                Cb(d, a, b, c);
            });
        });
        Xb([ "columns().order()", "column().order()" ], function(a) {
            var b = this;
            return this.iterator("table", function(c, e) {
                var f = [];
                d.each(b[e], function(b, c) {
                    f.push([ c, a ]);
                });
                c.aaSorting = f;
            });
        });
        Xb("search()", function(a, b, e, f) {
            var g = this.context;
            return a === c ? 0 !== g.length ? g[0].oPreviousSearch.sSearch : c : this.iterator("table", function(c) {
                c.oFeatures.bFilter && V(c, d.extend({}, c.oPreviousSearch, {
                    sSearch: a + "",
                    bRegex: null === b ? !1 : b,
                    bSmart: null === e ? !0 : e,
                    bCaseInsensitive: null === f ? !0 : f
                }), 1);
            });
        });
        Yb("columns().search()", "column().search()", function(a, b, e, f) {
            return this.iterator("column", function(g, h) {
                var i = g.aoPreSearchCols;
                if (a === c) return i[h].sSearch;
                g.oFeatures.bFilter && (d.extend(i[h], {
                    sSearch: a + "",
                    bRegex: null === b ? !1 : b,
                    bSmart: null === e ? !0 : e,
                    bCaseInsensitive: null === f ? !0 : f
                }), V(g, g.oPreviousSearch, 1));
            });
        });
        Xb("state()", function() {
            return this.context.length ? this.context[0].oSavedState : null;
        });
        Xb("state.clear()", function() {
            return this.iterator("table", function(a) {
                a.fnStateSaveCallback.call(a.oInstance, a, {});
            });
        });
        Xb("state.loaded()", function() {
            return this.context.length ? this.context[0].oLoadedState : null;
        });
        Xb("state.save()", function() {
            return this.iterator("table", function(a) {
                Fb(a);
            });
        });
        Ub.versionCheck = Ub.fnVersionCheck = function(a) {
            for (var b = Ub.version.split("."), a = a.split("."), c, d, e = 0, f = a.length; e < f; e++) if (c = parseInt(b[e], 10) || 0, 
            d = parseInt(a[e], 10) || 0, c !== d) return c > d;
            return !0;
        };
        Ub.isDataTable = Ub.fnIsDataTable = function(a) {
            var b = d(a).get(0), c = !1;
            d.each(Ub.settings, function(a, d) {
                if (d.nTable === b || d.nScrollHead === b || d.nScrollFoot === b) c = !0;
            });
            return c;
        };
        Ub.tables = Ub.fnTables = function(a) {
            return jQuery.map(Ub.settings, function(b) {
                if (!a || a && d(b.nTable).is(":visible")) return b.nTable;
            });
        };
        Ub.camelToHungarian = f;
        Xb("$()", function(a, b) {
            var c = this.rows(b).nodes(), c = d(c);
            return d([].concat(c.filter(a).toArray(), c.find(a).toArray()));
        });
        d.each([ "on", "one", "off" ], function(a, b) {
            Xb(b + "()", function() {
                var a = Array.prototype.slice.call(arguments);
                a[0].match(/\.dt\b/) || (a[0] += ".dt");
                var c = d(this.tables().nodes());
                c[b].apply(c, a);
                return this;
            });
        });
        Xb("clear()", function() {
            return this.iterator("table", function(a) {
                C(a);
            });
        });
        Xb("settings()", function() {
            return new Wb(this.context, this.context);
        });
        Xb("data()", function() {
            return this.iterator("table", function(a) {
                return jc(a.aoData, "_aData");
            }).flatten();
        });
        Xb("destroy()", function(b) {
            b = b || !1;
            return this.iterator("table", function(c) {
                var e = c.nTableWrapper.parentNode, f = c.oClasses, g = c.nTable, h = c.nTBody, i = c.nTHead, j = c.nTFoot, k = d(g), h = d(h), l = d(c.nTableWrapper), m = d.map(c.aoData, function(a) {
                    return a.nTr;
                }), n;
                c.bDestroying = !0;
                Nb(c, "aoDestroyCallback", "destroy", [ c ]);
                b || new Wb(c).columns().visible(!0);
                l.unbind(".DT").find(":not(tbody *)").unbind(".DT");
                d(a).unbind(".DT-" + c.sInstance);
                g != i.parentNode && (k.children("thead").detach(), k.append(i));
                j && g != j.parentNode && (k.children("tfoot").detach(), k.append(j));
                k.detach();
                l.detach();
                c.aaSorting = [];
                c.aaSortingFixed = [];
                Db(c);
                d(m).removeClass(c.asStripeClasses.join(" "));
                d("th, td", i).removeClass(f.sSortable + " " + f.sSortableAsc + " " + f.sSortableDesc + " " + f.sSortableNone);
                c.bJUI && (d("th span." + f.sSortIcon + ", td span." + f.sSortIcon, i).detach(), 
                d("th, td", i).each(function() {
                    var a = d("div." + f.sSortJUIWrapper, this);
                    d(this).append(a.contents());
                    a.detach();
                }));
                !b && e && e.insertBefore(g, c.nTableReinsertBefore);
                h.children().detach();
                h.append(m);
                k.css("width", c.sDestroyWidth).removeClass(f.sTable);
                (n = c.asDestroyStripes.length) && h.children().each(function(a) {
                    d(this).addClass(c.asDestroyStripes[a % n]);
                });
                e = d.inArray(c, Ub.settings);
                -1 !== e && Ub.settings.splice(e, 1);
            });
        });
        Ub.version = "1.10.2";
        Ub.settings = [];
        Ub.models = {};
        Ub.models.oSearch = {
            bCaseInsensitive: !0,
            sSearch: "",
            bRegex: !1,
            bSmart: !0
        };
        Ub.models.oRow = {
            nTr: null,
            anCells: null,
            _aData: [],
            _aSortData: null,
            _aFilterData: null,
            _sFilterRow: null,
            _sRowStripe: "",
            src: null
        };
        Ub.models.oColumn = {
            idx: null,
            aDataSort: null,
            asSorting: null,
            bSearchable: null,
            bSortable: null,
            bVisible: null,
            _sManualType: null,
            _bAttrSrc: !1,
            fnCreatedCell: null,
            fnGetData: null,
            fnSetData: null,
            mData: null,
            mRender: null,
            nTh: null,
            nTf: null,
            sClass: null,
            sContentPadding: null,
            sDefaultContent: null,
            sName: null,
            sSortDataType: "std",
            sSortingClass: null,
            sSortingClassJUI: null,
            sTitle: null,
            sType: null,
            sWidth: null,
            sWidthOrig: null
        };
        Ub.defaults = {
            aaData: null,
            aaSorting: [ [ 0, "asc" ] ],
            aaSortingFixed: [],
            ajax: null,
            aLengthMenu: [ 10, 25, 50, 100 ],
            aoColumns: null,
            aoColumnDefs: null,
            aoSearchCols: [],
            asStripeClasses: null,
            bAutoWidth: !0,
            bDeferRender: !1,
            bDestroy: !1,
            bFilter: !0,
            bInfo: !0,
            bJQueryUI: !1,
            bLengthChange: !0,
            bPaginate: !0,
            bProcessing: !1,
            bRetrieve: !1,
            bScrollCollapse: !1,
            bServerSide: !1,
            bSort: !0,
            bSortMulti: !0,
            bSortCellsTop: !1,
            bSortClasses: !0,
            bStateSave: !1,
            fnCreatedRow: null,
            fnDrawCallback: null,
            fnFooterCallback: null,
            fnFormatNumber: function(a) {
                return a.toString().replace(/\B(?=(\d{3})+(?!\d))/g, this.oLanguage.sThousands);
            },
            fnHeaderCallback: null,
            fnInfoCallback: null,
            fnInitComplete: null,
            fnPreDrawCallback: null,
            fnRowCallback: null,
            fnServerData: null,
            fnServerParams: null,
            fnStateLoadCallback: function(a) {
                try {
                    return JSON.parse((-1 === a.iStateDuration ? sessionStorage : localStorage).getItem("DataTables_" + a.sInstance + "_" + location.pathname));
                } catch (b) {}
            },
            fnStateLoadParams: null,
            fnStateLoaded: null,
            fnStateSaveCallback: function(a, b) {
                try {
                    (-1 === a.iStateDuration ? sessionStorage : localStorage).setItem("DataTables_" + a.sInstance + "_" + location.pathname, JSON.stringify(b));
                } catch (c) {}
            },
            fnStateSaveParams: null,
            iStateDuration: 7200,
            iDeferLoading: null,
            iDisplayLength: 10,
            iDisplayStart: 0,
            iTabIndex: 0,
            oClasses: {},
            oLanguage: {
                oAria: {
                    sSortAscending: ": activate to sort column ascending",
                    sSortDescending: ": activate to sort column descending"
                },
                oPaginate: {
                    sFirst: "First",
                    sLast: "Last",
                    sNext: "Next",
                    sPrevious: "Previous"
                },
                sEmptyTable: "No data available in table",
                sInfo: "Showing _START_ to _END_ of _TOTAL_ entries",
                sInfoEmpty: "Showing 0 to 0 of 0 entries",
                sInfoFiltered: "(filtered from _MAX_ total entries)",
                sInfoPostFix: "",
                sDecimal: "",
                sThousands: ",",
                sLengthMenu: "Show _MENU_ entries",
                sLoadingRecords: "Loading...",
                sProcessing: "Processing...",
                sSearch: "Search:",
                sSearchPlaceholder: "",
                sUrl: "",
                sZeroRecords: "No matching records found"
            },
            oSearch: d.extend({}, Ub.models.oSearch),
            sAjaxDataProp: "data",
            sAjaxSource: null,
            sDom: "lfrtip",
            sPaginationType: "simple_numbers",
            sScrollX: "",
            sScrollXInner: "",
            sScrollY: "",
            sServerMethod: "GET",
            renderer: null
        };
        e(Ub.defaults);
        Ub.defaults.column = {
            aDataSort: null,
            iDataSort: -1,
            asSorting: [ "asc", "desc" ],
            bSearchable: !0,
            bSortable: !0,
            bVisible: !0,
            fnCreatedCell: null,
            mData: null,
            mRender: null,
            sCellType: "td",
            sClass: "",
            sContentPadding: "",
            sDefaultContent: null,
            sName: "",
            sSortDataType: "std",
            sTitle: null,
            sType: null,
            sWidth: null
        };
        e(Ub.defaults.column);
        Ub.models.oSettings = {
            oFeatures: {
                bAutoWidth: null,
                bDeferRender: null,
                bFilter: null,
                bInfo: null,
                bLengthChange: null,
                bPaginate: null,
                bProcessing: null,
                bServerSide: null,
                bSort: null,
                bSortMulti: null,
                bSortClasses: null,
                bStateSave: null
            },
            oScroll: {
                bCollapse: null,
                iBarWidth: 0,
                sX: null,
                sXInner: null,
                sY: null
            },
            oLanguage: {
                fnInfoCallback: null
            },
            oBrowser: {
                bScrollOversize: !1,
                bScrollbarLeft: !1
            },
            ajax: null,
            aanFeatures: [],
            aoData: [],
            aiDisplay: [],
            aiDisplayMaster: [],
            aoColumns: [],
            aoHeader: [],
            aoFooter: [],
            oPreviousSearch: {},
            aoPreSearchCols: [],
            aaSorting: null,
            aaSortingFixed: [],
            asStripeClasses: null,
            asDestroyStripes: [],
            sDestroyWidth: 0,
            aoRowCallback: [],
            aoHeaderCallback: [],
            aoFooterCallback: [],
            aoDrawCallback: [],
            aoRowCreatedCallback: [],
            aoPreDrawCallback: [],
            aoInitComplete: [],
            aoStateSaveParams: [],
            aoStateLoadParams: [],
            aoStateLoaded: [],
            sTableId: "",
            nTable: null,
            nTHead: null,
            nTFoot: null,
            nTBody: null,
            nTableWrapper: null,
            bDeferLoading: !1,
            bInitialised: !1,
            aoOpenRows: [],
            sDom: null,
            sPaginationType: "two_button",
            iStateDuration: 0,
            aoStateSave: [],
            aoStateLoad: [],
            oSavedState: null,
            oLoadedState: null,
            sAjaxSource: null,
            sAjaxDataProp: null,
            bAjaxDataGet: !0,
            jqXHR: null,
            json: c,
            oAjaxData: c,
            fnServerData: null,
            aoServerParams: [],
            sServerMethod: null,
            fnFormatNumber: null,
            aLengthMenu: null,
            iDraw: 0,
            bDrawing: !1,
            iDrawError: -1,
            _iDisplayLength: 10,
            _iDisplayStart: 0,
            _iRecordsTotal: 0,
            _iRecordsDisplay: 0,
            bJUI: null,
            oClasses: {},
            bFiltered: !1,
            bSorted: !1,
            bSortCellsTop: null,
            oInit: null,
            aoDestroyCallback: [],

            fnRecordsTotal: function() {
                return "ssp" == Qb(this) ? 1 * this._iRecordsTotal : this.aiDisplayMaster.length;
            },
            fnRecordsDisplay: function() {
                return "ssp" == Qb(this) ? 1 * this._iRecordsDisplay : this.aiDisplay.length;
            },
            fnDisplayEnd: function() {
                var a = this._iDisplayLength, b = this._iDisplayStart, c = b + a, d = this.aiDisplay.length, e = this.oFeatures, f = e.bPaginate;
                return e.bServerSide ? !1 === f || -1 === a ? b + d : Math.min(b + a, this._iRecordsDisplay) : !f || c > d || -1 === a ? d : c;
            },
            oInstance: null,
            sInstance: null,
            iTabIndex: 0,
            nScrollHead: null,
            nScrollFoot: null,
            aLastSort: [],
            oPlugins: {}
        };
        Ub.ext = Vb = {
            classes: {},
            errMode: "alert",
            feature: [],
            search: [],
            internal: {},
            legacy: {
                ajax: null
            },
            pager: {},
            renderer: {
                pageButton: {},
                header: {}
            },
            order: {},
            type: {
                detect: [],
                search: {},
                order: {}
            },
            _unique: 0,
            fnVersionCheck: Ub.fnVersionCheck,
            iApiIndex: 0,
            oJUIClasses: {},
            sVersion: Ub.version
        };
        d.extend(Vb, {
            afnFiltering: Vb.search,
            aTypes: Vb.type.detect,
            ofnSearch: Vb.type.search,
            oSort: Vb.type.order,
            afnSortData: Vb.order,
            aoFeatures: Vb.feature,
            oApi: Vb.internal,
            oStdClasses: Vb.classes,
            oPagination: Vb.pager
        });
        d.extend(Ub.ext.classes, {
            sTable: "dataTable",
            sNoFooter: "no-footer",
            sPageButton: "paginate_button",
            sPageButtonActive: "current",
            sPageButtonDisabled: "disabled",
            sStripeOdd: "odd",
            sStripeEven: "even",
            sRowEmpty: "dataTables_empty",
            sWrapper: "dataTables_wrapper",
            sFilter: "dataTables_filter",
            sInfo: "dataTables_info",
            sPaging: "dataTables_paginate paging_",
            sLength: "dataTables_length",
            sProcessing: "dataTables_processing",
            sSortAsc: "sorting_asc",
            sSortDesc: "sorting_desc",
            sSortable: "sorting",
            sSortableAsc: "sorting_asc_disabled",
            sSortableDesc: "sorting_desc_disabled",
            sSortableNone: "sorting_disabled",
            sSortColumn: "sorting_",
            sFilterInput: "",
            sLengthSelect: "",
            sScrollWrapper: "dataTables_scroll",
            sScrollHead: "dataTables_scrollHead",
            sScrollHeadInner: "dataTables_scrollHeadInner",
            sScrollBody: "dataTables_scrollBody",
            sScrollFoot: "dataTables_scrollFoot",
            sScrollFootInner: "dataTables_scrollFootInner",
            sHeaderTH: "",
            sFooterTH: "",
            sSortJUIAsc: "",
            sSortJUIDesc: "",
            sSortJUI: "",
            sSortJUIAscAllowed: "",
            sSortJUIDescAllowed: "",
            sSortJUIWrapper: "",
            sSortIcon: "",
            sJUIHeader: "",
            sJUIFooter: ""
        });
        var Ec = "", Ec = "", Fc = Ec + "ui-state-default", Gc = Ec + "css_right ui-icon ui-icon-", Hc = Ec + "fg-toolbar ui-toolbar ui-widget-header ui-helper-clearfix";
        d.extend(Ub.ext.oJUIClasses, Ub.ext.classes, {
            sPageButton: "fg-button ui-button " + Fc,
            sPageButtonActive: "ui-state-disabled",
            sPageButtonDisabled: "ui-state-disabled",
            sPaging: "dataTables_paginate fg-buttonset ui-buttonset fg-buttonset-multi ui-buttonset-multi paging_",
            sSortAsc: Fc + " sorting_asc",
            sSortDesc: Fc + " sorting_desc",
            sSortable: Fc + " sorting",
            sSortableAsc: Fc + " sorting_asc_disabled",
            sSortableDesc: Fc + " sorting_desc_disabled",
            sSortableNone: Fc + " sorting_disabled",
            sSortJUIAsc: Gc + "triangle-1-n",
            sSortJUIDesc: Gc + "triangle-1-s",
            sSortJUI: Gc + "carat-2-n-s",
            sSortJUIAscAllowed: Gc + "carat-1-n",
            sSortJUIDescAllowed: Gc + "carat-1-s",
            sSortJUIWrapper: "DataTables_sort_wrapper",
            sSortIcon: "DataTables_sort_icon",
            sScrollHead: "dataTables_scrollHead " + Fc,
            sScrollFoot: "dataTables_scrollFoot " + Fc,
            sHeaderTH: Fc,
            sFooterTH: Fc,
            sJUIHeader: Hc + " ui-corner-tl ui-corner-tr",
            sJUIFooter: Hc + " ui-corner-bl ui-corner-br"
        });
        var Ic = Ub.ext.pager;
        d.extend(Ic, {
            simple: function() {
                return [ "previous", "next" ];
            },
            full: function() {
                return [ "first", "previous", "next", "last" ];
            },
            simple_numbers: function(a, b) {
                return [ "previous", Rb(a, b), "next" ];
            },
            full_numbers: function(a, b) {
                return [ "first", "previous", Rb(a, b), "next", "last" ];
            },
            _numbers: Rb,
            numbers_length: 7
        });
        d.extend(!0, Ub.ext.renderer, {
            pageButton: {
                _: function(a, c, e, f, g, h) {
                    var i = a.oClasses, j = a.oLanguage.oPaginate, k, l, m = 0, n = function(b, c) {
                        var f, o, p, q, r = function(b) {
                            kb(a, b.data.action, true);
                        };
                        f = 0;
                        for (o = c.length; f < o; f++) {
                            q = c[f];
                            if (d.isArray(q)) {
                                p = d("<" + (q.DT_el || "div") + "/>").appendTo(b);
                                n(p, q);
                            } else {
                                l = k = "";
                                switch (q) {
                                  case "ellipsis":
                                    b.append("<span>&hellip;</span>");
                                    break;

                                  case "first":
                                    k = j.sFirst;
                                    l = q + (g > 0 ? "" : " " + i.sPageButtonDisabled);
                                    break;

                                  case "previous":
                                    k = j.sPrevious;
                                    l = q + (g > 0 ? "" : " " + i.sPageButtonDisabled);
                                    break;

                                  case "next":
                                    k = j.sNext;
                                    l = q + (g < h - 1 ? "" : " " + i.sPageButtonDisabled);
                                    break;

                                  case "last":
                                    k = j.sLast;
                                    l = q + (g < h - 1 ? "" : " " + i.sPageButtonDisabled);
                                    break;

                                  default:
                                    k = q + 1;
                                    l = g === q ? i.sPageButtonActive : "";
                                }
                                if (k) {
                                    p = d("<a>", {
                                        "class": i.sPageButton + " " + l,
                                        "aria-controls": a.sTableId,
                                        "data-dt-idx": m,
                                        tabindex: a.iTabIndex,
                                        id: 0 === e && "string" === typeof q ? a.sTableId + "_" + q : null
                                    }).html(k).appendTo(b);
                                    Lb(p, {
                                        action: q
                                    }, r);
                                    m++;
                                }
                            }
                        }
                    };
                    try {
                        var o = d(b.activeElement).data("dt-idx");
                        n(d(c).empty(), f);
                        null !== o && d(c).find("[data-dt-idx=" + o + "]").focus();
                    } catch (p) {}
                }
            }
        });
        var Jc = function(a, b, c, d) {
            if (!a || "-" === a) return -1/0;
            b && (a = gc(a, b));
            a.replace && (c && (a = a.replace(c, "")), d && (a = a.replace(d, "")));
            return 1 * a;
        };
        d.extend(Vb.type.order, {
            "date-pre": function(a) {
                return Date.parse(a) || 0;
            },
            "html-pre": function(a) {
                return ec(a) ? "" : a.replace ? a.replace(/<.*?>/g, "").toLowerCase() : a + "";
            },
            "string-pre": function(a) {
                return ec(a) ? "" : "string" === typeof a ? a.toLowerCase() : !a.toString ? "" : a.toString();
            },
            "string-asc": function(a, b) {
                return a < b ? -1 : a > b ? 1 : 0;
            },
            "string-desc": function(a, b) {
                return a < b ? 1 : a > b ? -1 : 0;
            }
        });
        Sb("");
        d.extend(Ub.ext.type.detect, [ function(a, b) {
            var c = b.oLanguage.sDecimal;
            return hc(a, c) ? "num" + c : null;
        }, function(a) {
            if (a && (!ac.test(a) || !bc.test(a))) return null;
            var b = Date.parse(a);
            return null !== b && !isNaN(b) || ec(a) ? "date" : null;
        }, function(a, b) {
            var c = b.oLanguage.sDecimal;
            return hc(a, c, !0) ? "num-fmt" + c : null;
        }, function(a, b) {
            var c = b.oLanguage.sDecimal;
            return ic(a, c) ? "html-num" + c : null;
        }, function(a, b) {
            var c = b.oLanguage.sDecimal;
            return ic(a, c, !0) ? "html-num-fmt" + c : null;
        }, function(a) {
            return ec(a) || "string" === typeof a && -1 !== a.indexOf("<") ? "html" : null;
        } ]);
        d.extend(Ub.ext.type.search, {
            html: function(a) {
                return ec(a) ? a : "string" === typeof a ? a.replace($b, " ").replace(_b, "") : "";
            },
            string: function(a) {
                return ec(a) ? a : "string" === typeof a ? a.replace($b, " ") : a;
            }
        });
        d.extend(!0, Ub.ext.renderer, {
            header: {
                _: function(a, b, c, e) {
                    d(a.nTable).on("order.dt.DT", function(d, f, g, h) {
                        if (a === f) {
                            d = c.idx;
                            b.removeClass(c.sSortingClass + " " + e.sSortAsc + " " + e.sSortDesc).addClass("asc" == h[d] ? e.sSortAsc : "desc" == h[d] ? e.sSortDesc : c.sSortingClass);
                        }
                    });
                },
                jqueryui: function(a, b, c, e) {
                    var f = c.idx;
                    d("<div/>").addClass(e.sSortJUIWrapper).append(b.contents()).append(d("<span/>").addClass(e.sSortIcon + " " + c.sSortingClassJUI)).appendTo(b);
                    d(a.nTable).on("order.dt.DT", function(d, g, h, i) {
                        if (a === g) {
                            b.removeClass(e.sSortAsc + " " + e.sSortDesc).addClass("asc" == i[f] ? e.sSortAsc : "desc" == i[f] ? e.sSortDesc : c.sSortingClass);
                            b.find("span." + e.sSortIcon).removeClass(e.sSortJUIAsc + " " + e.sSortJUIDesc + " " + e.sSortJUI + " " + e.sSortJUIAscAllowed + " " + e.sSortJUIDescAllowed).addClass("asc" == i[f] ? e.sSortJUIAsc : "desc" == i[f] ? e.sSortJUIDesc : c.sSortingClassJUI);
                        }
                    });
                }
            }
        });
        Ub.render = {
            number: function(a, b, c, d) {
                return {
                    display: function(e) {
                        var f = 0 > e ? "-" : "", e = Math.abs(parseFloat(e)), g = parseInt(e, 10), e = c ? b + (e - g).toFixed(c).substring(2) : "";
                        return f + (d || "") + g.toString().replace(/\B(?=(\d{3})+(?!\d))/g, a) + e;
                    }
                };
            }
        };
        d.extend(Ub.ext.internal, {
            _fnExternApiFunc: Tb,
            _fnBuildAjax: P,
            _fnAjaxUpdate: Q,
            _fnAjaxParameters: R,
            _fnAjaxUpdateDraw: S,
            _fnAjaxDataSrc: T,
            _fnAddColumn: l,
            _fnColumnOptions: m,
            _fnAdjustColumnSizing: n,
            _fnVisibleToColumnIndex: o,
            _fnColumnIndexToVisible: p,
            _fnVisbleColumns: q,
            _fnGetColumns: r,
            _fnColumnTypes: s,
            _fnApplyColumnDefs: t,
            _fnHungarianMap: e,
            _fnCamelToHungarian: f,
            _fnLanguageCompat: g,
            _fnBrowserDetect: j,
            _fnAddData: u,
            _fnAddTr: v,
            _fnNodeToDataIndex: function(a, b) {
                return b._DT_RowIndex !== c ? b._DT_RowIndex : null;
            },
            _fnNodeToColumnIndex: function(a, b, c) {
                return d.inArray(c, a.aoData[b].anCells);
            },
            _fnGetCellData: w,
            _fnSetCellData: x,
            _fnSplitObjNotation: y,
            _fnGetObjectDataFn: z,
            _fnSetObjectDataFn: A,
            _fnGetDataMaster: B,
            _fnClearTable: C,
            _fnDeleteIndex: D,
            _fnInvalidateRow: E,
            _fnGetRowElements: F,
            _fnCreateTr: G,
            _fnBuildHead: I,
            _fnDrawHead: J,
            _fnDraw: K,
            _fnReDraw: L,
            _fnAddOptionsHtml: M,
            _fnDetectHeader: N,
            _fnGetUniqueThs: O,
            _fnFeatureHtmlFilter: U,
            _fnFilterComplete: V,
            _fnFilterCustom: W,
            _fnFilterColumn: X,
            _fnFilter: Y,
            _fnFilterCreateSearch: Z,
            _fnEscapeRegex: $,
            _fnFilterData: _,
            _fnFeatureHtmlInfo: cb,
            _fnUpdateInfo: db,
            _fnInfoMacros: eb,
            _fnInitialise: fb,
            _fnInitComplete: gb,
            _fnLengthChange: hb,
            _fnFeatureHtmlLength: ib,
            _fnFeatureHtmlPaginate: jb,
            _fnPageChange: kb,
            _fnFeatureHtmlProcessing: lb,
            _fnProcessingDisplay: mb,
            _fnFeatureHtmlTable: nb,
            _fnScrollDraw: ob,
            _fnApplyToChildren: pb,
            _fnCalculateColumnWidths: qb,
            _fnThrottle: rb,
            _fnConvertToWidth: sb,
            _fnScrollingWidthAdjust: tb,
            _fnGetWidestNode: ub,
            _fnGetMaxLenString: vb,
            _fnStringToCss: wb,
            _fnScrollBarWidth: xb,
            _fnSortFlatten: yb,
            _fnSort: zb,
            _fnSortAria: Ab,
            _fnSortListener: Bb,
            _fnSortAttachListener: Cb,
            _fnSortingClasses: Db,
            _fnSortData: Eb,
            _fnSaveState: Fb,
            _fnLoadState: Gb,
            _fnSettingsFromNode: Hb,
            _fnLog: Ib,
            _fnMap: Jb,
            _fnBindAction: Lb,
            _fnCallbackReg: Mb,
            _fnCallbackFire: Nb,
            _fnLengthOverflow: Ob,
            _fnRenderer: Pb,
            _fnDataSource: Qb,
            _fnRowAttributes: H,
            _fnCalculateEnd: function() {}
        });
        d.fn.dataTable = Ub;
        d.fn.dataTableSettings = Ub.settings;
        d.fn.dataTableExt = Ub.ext;
        d.fn.DataTable = function(a) {
            return d(this).dataTable(a).api();
        };
        d.each(Ub, function(a, b) {
            d.fn.DataTable[a] = b;
        });
        return d.fn.dataTable;
    };
    "function" === typeof define && define.amd ? define("datatables", [ "jquery" ], d) : "object" === typeof exports ? d(require("jquery")) : jQuery && !jQuery.fn.dataTable && d(jQuery);
}(window, document);