**free
/if NOT defined(H_SPEC)
/define H_SPEC

/if NOT defined(UNIT_TEST)
ctl-opt nomain;
/endif
//  Standard H-Specs
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
ctl-opt ccsid(*CHAR: *jobrun);
ctl-opt reqprexp(*require);

/endif