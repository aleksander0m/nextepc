asn1c_headers = files('''
    ANY.h
    OCTET_STRING.h
    OPEN_TYPE.h
    constr_CHOICE.h
    BOOLEAN.h
    INTEGER.h
    NULL.h
    NativeEnumerated.h
    NativeInteger.h
    OBJECT_IDENTIFIER.h
    PrintableString.h
    asn_SEQUENCE_OF.h
    asn_SET_OF.h
    constr_SEQUENCE.h
    constr_SEQUENCE_OF.h
    constr_SET_OF.h
    asn_application.h
    asn_ioc.h
    asn_system.h
    asn_codecs.h
    asn_internal.h
    asn_random_fill.h
    asn_bit_data.h
    BIT_STRING.h
    asn_codecs_prim.h
    ber_tlv_length.h
    ber_tlv_tag.h
    ber_decoder.h
    der_encoder.h
    constr_TYPE.h
    constraints.h
    xer_support.h
    xer_decoder.h
    xer_encoder.h
    per_support.h
    per_decoder.h
    per_encoder.h
    per_opentype.h
    oer_decoder.h
    oer_encoder.h
    oer_support.h
'''.split())
#install_headers(asn1c_headers, subdir : 'open5gs/asn1c/common')

asn1c_sources = files('''
    ANY.c
    OPEN_TYPE.c
    BOOLEAN.c
    INTEGER.c
    NULL.c
    NativeEnumerated.c
    NativeInteger.c
    OBJECT_IDENTIFIER.c
    PrintableString.c
    asn_SEQUENCE_OF.c
    asn_SET_OF.c
    constr_CHOICE.c
    constr_SEQUENCE.c
    constr_SEQUENCE_OF.c
    constr_SET_OF.c
    asn_application.c
    asn_internal.c
    asn_random_fill.c
    asn_bit_data.c
    OCTET_STRING.c
    BIT_STRING.c
    asn_codecs_prim.c
    ber_tlv_length.c
    ber_tlv_tag.c
    ber_decoder.c
    der_encoder.c
    constr_TYPE.c
    constraints.c
    xer_support.c
    xer_decoder.c
    xer_encoder.c
    per_support.c
    per_decoder.c
    per_encoder.c
    per_opentype.c
    oer_decoder.c
    oer_encoder.c
    oer_support.c
    OPEN_TYPE_oer.c
    INTEGER_oer.c
    BIT_STRING_oer.c
    OCTET_STRING_oer.c
    NativeInteger_oer.c
    NativeEnumerated_oer.c
    constr_CHOICE_oer.c
    constr_SEQUENCE_oer.c
    constr_SET_OF_oer.c
'''.split())

libogs_asn1c = library('ogs-asn1c',
    sources : [asn1c_sources],
    install : true,
    include_directories : includes,
    dependencies : libogscore_dep,
)

libogs_asn1c_dep = declare_dependency(
    link_with : libogs_asn1c,
    include_directories : includes,
    dependencies : libogscore_dep,
)
