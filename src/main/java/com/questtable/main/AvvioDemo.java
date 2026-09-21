package com.questtable.main;

import com.questtable.config.PersistenceConfig;

/** Starts the downloadable desktop demo without console setup or a database. */
public final class AvvioDemo {
    private AvvioDemo() {
    }

    public static void main(String[] args) {
        PersistenceConfig.configuraTipoPersistenza(PersistenceConfig.DEMO);
        AvvioJavaFX.avvia();
    }
}
