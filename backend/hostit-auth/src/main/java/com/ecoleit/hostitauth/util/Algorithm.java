package com.ecoleit.hostitauth.util;

public enum Algorithm {
    SHA1("HmacSHA1"),
    SHA256("HmacSHA256"),
    SHA512("HmacSHA512");

    private final String hmacName;

    Algorithm(String hmacName) {
        this.hmacName = hmacName;
    }

    public String getHmacName() {
        return hmacName;
    }
}
