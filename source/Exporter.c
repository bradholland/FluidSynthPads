#include <fluidsynth.h>

int main()
{
    fluid_settings_t* const settings = new_fluid_settings();
    fluid_settings_setnum(settings, "synth.sample-rate", 48000.0);
    fluid_settings_setint(settings, "synth.parallel-render", 1);
    fluid_settings_setint(settings, "synth.threadsafe-api", 0);

    fluid_synth_t* const synth = new_fluid_synth(settings);
    fluid_synth_set_gain(synth, 1.0f);
    fluid_synth_set_polyphony(synth, 32);
    
    const int synthId = fluid_synth_sfload(synth, "./FluidPlug.sf2", 1);
    if (synthId == FLUID_FAILED) {
        fprintf(stderr, "Failed to load soundfont\n");
        return 1;
    }

    fluid_sfont_t* const sfont = fluid_synth_get_sfont_by_id(synth, synthId);
    if (!sfont) {
        fprintf(stderr, "Failed to get soundfont\n");
        return 1;
    }

    int count = 0;
    int bank = -1;
    fluid_preset_t* preset;

    fluid_sfont_iteration_start(sfont);
    while ((preset = fluid_sfont_iteration_next(sfont)) != NULL)
    {
        ++count;
        const int banknum = fluid_preset_get_banknum(preset) + 1;

        if (bank == -2)
            continue;

        if (bank == -1)
            bank = banknum;
        else if (bank != banknum)
            bank = -2;
    }

    printf("        lv2:maximum %i ;\n", count);
    printf("        lv2:scalePoint [\n");

    int index = 0;
    fluid_sfont_iteration_start(sfont);
    while ((preset = fluid_sfont_iteration_next(sfont)) != NULL)
    {
        const char* const name = fluid_preset_get_name(preset);

        if (index != 0)
            printf("        ] , [\n");

        printf("            rdfs:label \"");

#if 1
        if (bank == -2)
            printf("%03i:", fluid_preset_get_banknum(preset) + 1);

        if (count > 100)
            printf("%03i", index + 1);
        else if (count > 10)
            printf("%02i", index + 1);
        else
            printf("%i", index + 1);

        printf(" %s\" ;\n", name);
#else
        printf("%s\" ;\n", name);
#endif
        printf("            rdf:value %i ;\n", index);
        
        index++;
    }

    printf("        ] ;\n");

    delete_fluid_synth(synth);
    delete_fluid_settings(settings);

    return 0;
}