package foodiepass.server.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.HashMap;
import java.util.Map;

@Getter
@AllArgsConstructor
public enum Currency {

    /**
     * 대소문자 구분:
     * fromCurrencyName 및 fromISO4217Code 메소드는 현재 정확히 일치하는 문자열을 요구한다(대소문자 구분 포함).
     * 요구 사항에 따라 대소문자 구분 없이 일치하는 방식을 허용하면 사용자 친화적일 수 있다.
     */

    AFGHAN_AFGHANI("Afghan Afghani", "AFN"),
    ALBANIAN_LEK("Albanian Lek", "ALL"),
    ALGERIAN_DINAR("Algerian Dinar", "DZD"),
    ANGOLAN_KWANZA("Angolan Kwanza", "AOA"),
    ARGENTINE_PESO("Argentine Peso", "ARS"),
    ARMENIAN_DRAM("Armenian Dram", "AMD"),
    ARUBAN_FLORIN("Aruban Florin", "AWG"),
    AUSTRALIAN_DOLLAR("Australian Dollar", "AUD"),
    AZERBAIJANI_MANAT("Azerbaijani Manat", "AZN"),
    BAHAMIAN_DOLLAR("Bahamian Dollar", "BSD"),
    BAHRAINI_DINAR("Bahraini Dinar", "BHD"),
    BAJAN_DOLLAR("Bajan Dollar", "BBD"),
    BANGLADESHI_TAKA("Bangladeshi Taka", "BDT"),
    BELARUSIAN_RUBLE("Belarusian Ruble", "BYN"),
    BELIZE_DOLLAR("Belize Dollar", "BZD"),
    BERMUDA_DOLLAR("Bermuda Dollar", "BMD"),
    BHUTANESE_NGULTRUM("Bhutanese Ngultrum", "BTN"),
    BOLIVIAN_BOLIVIANO("Bolivian Boliviano", "BOB"),
    BOSNIA_HERZEGOVINA_CONVERTIBLE_MARKA("Bosnia-Herzegovina Convertible Marka", "BAM"),
    BOTSWANAN_PULA("Botswanan Pula", "BWP"),
    BRAZILIAN_REAL("Brazilian Real", "BRL"),
    BRUNEI_DOLLAR("Brunei Dollar", "BND"),
    BULGARIAN_LEV("Bulgarian Lev", "BGN"),
    BURUNDIAN_FRANC("Burundian Franc", "BIF"),
    CFP_FRANC("CFP Franc", "XPF"),
    CAMBODIAN_RIEL("Cambodian Riel", "KHR"),
    CANADIAN_DOLLAR("Canadian Dollar", "CAD"),
    CAPE_VERDEAN_ESCUDO("Cape Verdean Escudo", "CVE"),
    CAYMAN_ISLANDS_DOLLAR("Cayman Islands Dollar", "KYD"),
    CENTRAL_AFRICAN_CFA_FRANC("Central African CFA Franc", "XAF"),
    CHILEAN_PESO("Chilean Peso", "CLP"),
    CHILEAN_UNIT_OF_ACCOUNT_UF("Chilean Unit of Account (UF)", "CLF"),
    CHINESE_YUAN("Chinese Yuan", "CNY"),
    CHINESE_YUAN_OFFSHORE("Chinese Yuan (offshore)", "CNH"),
    COLOMBIAN_PESO("Colombian Peso", "COP"),
    COMORIAN_FRANC("Comorian Franc", "KMF"),
    CONGOLESE_FRANC("Congolese Franc", "CDF"),
    COSTA_RICAN_COLON("Costa Rican Colón", "CRC"),
    CUBAN_PESO("Cuban Peso", "CUP"),
    CZECH_KORUNA("Czech Koruna", "CZK"),
    DANISH_KRONE("Danish Krone", "DKK"),
    DJIBOUTIAN_FRANC("Djiboutian Franc", "DJF"),
    DOMINICAN_PESO("Dominican Peso", "DOP"),
    EAST_CARIBBEAN_DOLLAR("East Caribbean Dollar", "XCD"),
    EGYPTIAN_POUND("Egyptian Pound", "EGP"),
    ETHIOPIAN_BIRR("Ethiopian Birr", "ETB"),
    EURO("Euro", "EUR"),
    FIJIAN_DOLLAR("Fijian Dollar", "FJD"),
    GAMBIAN_DALASI("Gambian Dalasi", "GMD"),
    GEORGIAN_LARI("Georgian Lari", "GEL"),
    GHANAIAN_CEDI("Ghanaian Cedi", "GHS"),
    GUATEMALAN_QUETZAL("Guatemalan Quetzal", "GTQ"),
    GUINEAN_FRANC("Guinean Franc", "GNF"),
    GUYANESE_DOLLAR("Guyanese Dollar", "GYD"),
    HAITIAN_GOURDE("Haitian Gourde", "HTG"),
    HONDURAN_LEMPIRA("Honduran Lempira", "HNL"),
    HONG_KONG_DOLLAR("Hong Kong Dollar", "HKD"),
    HUNGARIAN_FORINT("Hungarian Forint", "HUF"),
    ICELANDIC_KRONA("Icelandic Króna", "ISK"),
    INDIAN_RUPEE("Indian Rupee", "INR"),
    INDONESIAN_RUPIAH("Indonesian Rupiah", "IDR"),
    IRANIAN_RIAL("Iranian Rial", "IRR"),
    IRAQI_DINAR("Iraqi Dinar", "IQD"),
    ISRAELI_NEW_SHEKEL("Israeli New Shekel", "ILS"),
    JAMAICAN_DOLLAR("Jamaican Dollar", "JMD"),
    JAPANESE_YEN("Japanese Yen", "JPY"),
    JORDANIAN_DINAR("Jordanian Dinar", "JOD"),
    KAZAKHSTANI_TENGE("Kazakhstani Tenge", "KZT"),
    KENYAN_SHILLING("Kenyan Shilling", "KES"),
    KUWAITI_DINAR("Kuwaiti Dinar", "KWD"),
    KYRGYZSTANI_SOM("Kyrgyzstani Som", "KGS"),
    LAOTIAN_KIP("Laotian Kip", "LAK"),
    LEBANESE_POUND("Lebanese Pound", "LBP"),
    LESOTHO_LOTI("Lesotho Loti", "LSL"),
    LIBERIAN_DOLLAR("Liberian Dollar", "LRD"),
    LIBYAN_DINAR("Libyan Dinar", "LYD"),
    MACANESE_PATACA("Macanese Pataca", "MOP"),
    MACEDONIAN_DENAR("Macedonian Denar", "MKD"),
    MALAGASY_ARIARY("Malagasy Ariary", "MGA"),
    MALAWIAN_KWACHA("Malawian Kwacha", "MWK"),
    MALAYSIAN_RINGGIT("Malaysian Ringgit", "MYR"),
    MALDIVIAN_RUFIYAA("Maldivian Rufiyaa", "MVR"),
    MAURITANIAN_OUGUIYA("Mauritanian Ouguiya", "MRU"),
    MAURITIAN_RUPEE("Mauritian Rupee", "MUR"),
    MEXICAN_PESO("Mexican Peso", "MXN"),
    MOLDOVAN_LEU("Moldovan Leu", "MDL"),
    MOROCCAN_DIRHAM("Moroccan Dirham", "MAD"),
    MOZAMBICAN_METICAL("Mozambican Metical", "MZN"),
    MYANMAR_KYAT("Myanmar Kyat", "MMK"),
    NAMIBIAN_DOLLAR("Namibian Dollar", "NAD"),
    NEPALESE_RUPEE("Nepalese Rupee", "NPR"),
    NETHERLANDS_ANTILLEAN_GUILDER("Netherlands Antillean Guilder", "ANG"),
    NEW_TAIWAN_DOLLAR("New Taiwan Dollar", "TWD"),
    NEW_ZEALAND_DOLLAR("New Zealand Dollar", "NZD"),
    NICARAGUAN_CORDOBA("Nicaraguan Córdoba", "NIO"),
    NIGERIAN_NAIRA("Nigerian Naira", "NGN"),
    NORWEGIAN_KRONE("Norwegian Krone", "NOK"),
    OMANI_RIAL("Omani Rial", "OMR"),
    PAKISTANI_RUPEE("Pakistani Rupee", "PKR"),
    PANAMANIAN_BALBOA("Panamanian Balboa", "PAB"),
    PAPUA_NEW_GUINEAN_KINA("Papua New Guinean Kina", "PGK"),
    PARAGUAYAN_GUARANI("Paraguayan Guarani", "PYG"),
    PHILIPPINE_PESO("Philippine Peso", "PHP"),
    POLISH_ZLOTY("Polish Złoty", "PLN"),
    POUND_STERLING("Pound Sterling", "GBP"),
    QATARI_RIYAL("Qatari Riyal", "QAR"),
    ROMANIAN_LEU("Romanian Leu", "RON"),
    RUSSIAN_RUBLE("Russian Ruble", "RUB"),
    RWANDAN_FRANC("Rwandan Franc", "RWF"),
    SALVADORAN_COLON("Salvadoran Colón", "SVC"),
    SAUDI_RIYAL("Saudi Riyal", "SAR"),
    SERBIAN_DINAR("Serbian Dinar", "RSD"),
    SEYCHELLOIS_RUPEE("Seychellois Rupee", "SCR"),
    SIERRA_LEONEAN_LEONE("Sierra Leonean Leone", "SLL"),
    SINGAPORE_DOLLAR("Singapore Dollar", "SGD"),
    SOL("Sol", "PEN"),
    SOLOMON_ISLANDS_DOLLAR("Solomon Islands Dollar", "SBD"),
    SOMALI_SHILLING("Somali Shilling", "SOS"),
    SOUTH_AFRICAN_RAND("South African Rand", "ZAR"),
    SOUTH_KOREAN_WON("South Korean Won", "KRW"),
    SOVEREIGN_BOLIVAR("Sovereign Bolivar", "VES"),
    SRI_LANKAN_RUPEE("Sri Lankan Rupee", "LKR"),
    SUDANESE_POUND("Sudanese Pound", "SDG"),
    SURINAME_DOLLAR("Suriname Dollar", "SRD"),
    SWAZI_LILANGENI("Swazi Lilangeni", "SZL"),
    SWEDISH_KRONA("Swedish Krona", "SEK"),
    SWISS_FRANC("Swiss Franc", "CHF"),
    TAJIKISTANI_SOMONI("Tajikistani Somoni", "TJS"),
    TANZANIAN_SHILLING("Tanzanian Shilling", "TZS"),
    THAI_BAHT("Thai Baht", "THB"),
    TONGAN_PA_ANGA("Tongan Paʻanga", "TOP"),
    TRINIDAD_TOBAGO_DOLLAR("Trinidad & Tobago Dollar", "TTD"),
    TUNISIAN_DINAR("Tunisian Dinar", "TND"),
    TURKISH_LIRA("Turkish Lira", "TRY"),
    TURKMENISTANI_MANAT("Turkmenistani Manat", "TMT"),
    UGANDAN_SHILLING("Ugandan Shilling", "UGX"),
    UKRAINIAN_HRYVNIA("Ukrainian Hryvnia", "UAH"),
    UNITED_ARAB_EMIRATES_DIRHAM("United Arab Emirates Dirham", "AED"),
    UNITED_STATES_DOLLAR("United States Dollar", "USD"),
    URUGUAYAN_PESO("Uruguayan Peso", "UYU"),
    UZBEKISTANI_SOM("Uzbekistani Som", "UZS"),
    VIETNAMESE_DONG("Vietnamese Dong", "VND"),
    WEST_AFRICAN_CFA_FRANC("West African CFA Franc", "XOF"),
    YEMENI_RIAL("Yemeni Rial", "YER"),
    ZAMBIAN_KWACHA("Zambian Kwacha", "ZMW");

    private static final Map<String, Currency> BY_NAME = new HashMap<>();
    private static final Map<String, Currency> BY_CODE = new HashMap<>();


    static {
        for (Currency currency : values()) {
            BY_NAME.put(currency.currencyName.toUpperCase(), currency);
            BY_CODE.put(currency.ISO4217Code.toUpperCase(), currency);
        }
    }

    private final String currencyName;
    private final String ISO4217Code;

    public static Currency fromCurrencyName(final String currencyName) {
        return BY_NAME.get(currencyName.toUpperCase());
    }

    public static Currency fromISO4217Code(final String code) {
        return BY_CODE.get(code.toUpperCase());
    }
}
